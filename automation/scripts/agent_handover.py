#!/usr/bin/env python3
"""
Agent Handover System for Project Locus Fork A
Basic handover creation and reading for cross-machine coordination
"""

import json
import os
import datetime
import sys
from pathlib import Path

class AgentHandover:
    def __init__(self, base_dir="/tmp/locus_handover"):
        self.base_dir = Path(base_dir)
        self.base_dir.mkdir(exist_ok=True)
        
    def generate_ref_tag(self, handover_type="handover"):
        """Generate REF tag for handover using the shell script"""
        import subprocess
        script_path = Path(__file__).parent / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "artifact", f"agent-{handover_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def create_handover(self, from_agent, to_agent, task_context, decision_context=None):
        """Create a handover from one agent to another"""
        ref_tag = self.generate_ref_tag("handover")
        timestamp = datetime.datetime.now().isoformat()
        
        handover_data = {
            "ref_tag": ref_tag,
            "handover_type": "agent_coordination",
            "created_at": timestamp,
            "from_agent": from_agent,
            "to_agent": to_agent,
            "task_context": task_context,
            "decision_context": decision_context or {},
            "status": "pending",
            "machine_source": os.uname().nodename,
            "priority": "normal"
        }
        
        # Write handover file
        handover_file = self.base_dir / f"handover_{ref_tag}.json"
        with open(handover_file, 'w') as f:
            json.dump(handover_data, f, indent=2)
            
        # Update handover index
        self._update_handover_index(ref_tag, handover_data)
        
        print(f"✓ Handover created: {ref_tag}")
        print(f"  From: {from_agent}")
        print(f"  To: {to_agent}")
        print(f"  File: {handover_file}")
        
        return ref_tag
    
    def read_handover(self, ref_tag):
        """Read a handover by REF tag"""
        handover_file = self.base_dir / f"handover_{ref_tag}.json"
        
        if not handover_file.exists():
            print(f"✗ Handover not found: {ref_tag}")
            return None
            
        with open(handover_file, 'r') as f:
            handover_data = json.load(f)
            
        print(f"✓ Handover retrieved: {ref_tag}")
        print(f"  From: {handover_data['from_agent']}")
        print(f"  To: {handover_data['to_agent']}")
        print(f"  Status: {handover_data['status']}")
        print(f"  Created: {handover_data['created_at']}")
        
        return handover_data
    
    def complete_handover(self, ref_tag, completion_notes=None):
        """Mark a handover as completed"""
        handover_file = self.base_dir / f"handover_{ref_tag}.json"
        
        if not handover_file.exists():
            print(f"✗ Handover not found: {ref_tag}")
            return False
            
        with open(handover_file, 'r') as f:
            handover_data = json.load(f)
            
        handover_data["status"] = "completed"
        handover_data["completed_at"] = datetime.datetime.now().isoformat()
        handover_data["completion_notes"] = completion_notes or ""
        
        with open(handover_file, 'w') as f:
            json.dump(handover_data, f, indent=2)
            
        self._update_handover_index(ref_tag, handover_data)
        
        print(f"✓ Handover completed: {ref_tag}")
        return True
    
    def list_pending_handovers(self, for_agent=None):
        """List all pending handovers, optionally filtered by target agent"""
        index_file = self.base_dir / "handover_index.json"
        
        if not index_file.exists():
            print("No handovers found")
            return []
            
        with open(index_file, 'r') as f:
            index = json.load(f)
            
        pending = [h for h in index.get("handovers", []) 
                  if h["status"] == "pending"]
                  
        if for_agent:
            pending = [h for h in pending if h["to_agent"] == for_agent]
            
        print(f"✓ Found {len(pending)} pending handovers")
        for handover in pending:
            print(f"  - {handover['ref_tag']}: {handover['from_agent']} → {handover['to_agent']}")
            
        return pending
    
    def _update_handover_index(self, ref_tag, handover_data):
        """Update the handover index with current handover"""
        index_file = self.base_dir / "handover_index.json"
        
        if index_file.exists():
            with open(index_file, 'r') as f:
                index = json.load(f)
        else:
            index = {"handovers": [], "last_updated": None}
            
        # Remove existing entry for this ref_tag
        index["handovers"] = [h for h in index["handovers"] 
                            if h["ref_tag"] != ref_tag]
        
        # Add updated entry
        index["handovers"].append({
            "ref_tag": ref_tag,
            "from_agent": handover_data["from_agent"],
            "to_agent": handover_data["to_agent"],
            "status": handover_data["status"],
            "created_at": handover_data["created_at"],
            "machine_source": handover_data["machine_source"]
        })
        
        index["last_updated"] = datetime.datetime.now().isoformat()
        
        with open(index_file, 'w') as f:
            json.dump(index, f, indent=2)

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 agent_handover.py create <from_agent> <to_agent> <task_description>")
        print("  python3 agent_handover.py read <ref_tag>")
        print("  python3 agent_handover.py complete <ref_tag> [completion_notes]")
        print("  python3 agent_handover.py list [agent_name]")
        sys.exit(1)
        
    handover = AgentHandover()
    command = sys.argv[1]
    
    if command == "create":
        if len(sys.argv) < 5:
            print("Error: create requires from_agent, to_agent, and task_description")
            sys.exit(1)
        from_agent = sys.argv[2]
        to_agent = sys.argv[3]
        task_context = sys.argv[4]
        decision_context = {"priority": "normal", "requires_human_approval": False}
        ref_tag = handover.create_handover(from_agent, to_agent, task_context, decision_context)
        print(f"Handover REF: {ref_tag}")
        
    elif command == "read":
        if len(sys.argv) < 3:
            print("Error: read requires ref_tag")
            sys.exit(1)
        ref_tag = sys.argv[2]
        handover_data = handover.read_handover(ref_tag)
        if handover_data:
            print(json.dumps(handover_data, indent=2))
            
    elif command == "complete":
        if len(sys.argv) < 3:
            print("Error: complete requires ref_tag")
            sys.exit(1)
        ref_tag = sys.argv[2]
        completion_notes = sys.argv[3] if len(sys.argv) > 3 else None
        handover.complete_handover(ref_tag, completion_notes)
        
    elif command == "list":
        for_agent = sys.argv[2] if len(sys.argv) > 2 else None
        handovers = handover.list_pending_handovers(for_agent)
        
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()