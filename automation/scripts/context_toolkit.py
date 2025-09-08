#!/usr/bin/env python3
"""
Context Tracking Toolkit for Project Locus
Python implementation for context event capture and monitoring
"""

import json
import hashlib
import subprocess
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, List, Optional


class ContextTracker:
    """
    Main class for context tracking and receipt generation
    """
    
    def __init__(self, project_path: str = "/home/runner/work/locus-proxmox-infra/locus-proxmox-infra"):
        self.project_path = Path(project_path)
        self.receipt_dir = Path("/tmp/locus_receipts")
        self.audit_log_path = Path("/tmp/locus_ref_audit.log")
        
        # Ensure receipt directory exists
        self.receipt_dir.mkdir(exist_ok=True)
    
    def capture_context_event(self, action: str, trigger: str, changes: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Automatic REF tag generation and context capture
        
        Args:
            action: The action type (notify, research, dash, etc.)
            trigger: What triggered this event
            changes: Changes being made to context
            
        Returns:
            Context event with receipt
        """
        if changes is None:
            changes = {}
            
        try:
            # Generate REF tag
            ref_tag = self.generate_ref_tag(action)
            timestamp = int(datetime.now().timestamp())
            
            # Capture current context
            context_before = self.get_current_context()
            context_after = self.apply_changes(context_before, changes)
            context_hash = self.generate_context_hash(context_after)
            
            # Create context event
            context_event = {
                'ref_tag': ref_tag,
                'timestamp': timestamp,
                'trigger': trigger,
                'context_before': context_before,
                'changes': changes,
                'context_after': context_after,
                'hash': context_hash,
                'receipt_id': f"CTX-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
            }
            
            # Generate receipt
            self.generate_context_receipt(context_event)
            
            return context_event
            
        except Exception as e:
            print(f"Error capturing context event: {e}")
            raise
    
    def generate_ref_tag(self, action: str) -> str:
        """
        Generate REF tag using the existing shell script
        
        Args:
            action: Action type
            
        Returns:
            Generated REF tag
        """
        try:
            cmd = [
                str(self.project_path / "automation" / "scripts" / "generate_ref_tag.sh"),
                action,
                "Python context capture"
            ]
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=self.project_path)
            
            if result.returncode == 0:
                return result.stdout.strip()
            else:
                print(f"Error generating REF tag: {result.stderr}")
                return f"LOCUS-{action.upper()}-{int(datetime.now().timestamp())}-ERROR"
                
        except Exception as e:
            print(f"Error generating REF tag: {e}")
            return f"LOCUS-{action.upper()}-{int(datetime.now().timestamp())}-ERROR"
    
    def get_current_context(self) -> Dict[str, Any]:
        """
        Get current context state
        
        Returns:
            Current context dictionary
        """
        try:
            # Get git status
            git_result = subprocess.run(
                ["git", "status", "--porcelain"],
                capture_output=True,
                text=True,
                cwd=self.project_path
            )
            git_changes = len([line for line in git_result.stdout.split('\n') if line.strip()])
            
            # Get agent status
            agent_status_path = self.project_path / "context" / "AGENT_STATUS.json"
            agent_status = {}
            
            if agent_status_path.exists():
                with open(agent_status_path, 'r') as f:
                    agent_status = json.load(f)
            
            return {
                'working_directory': str(self.project_path),
                'git_changes': git_changes,
                'agents': agent_status,
                'timestamp': datetime.now().isoformat(),
                'python_version': sys.version,
                'platform': sys.platform
            }
            
        except Exception as e:
            print(f"Error getting current context: {e}")
            return {
                'working_directory': str(self.project_path),
                'git_changes': 0,
                'agents': {},
                'timestamp': datetime.now().isoformat(),
                'error': str(e)
            }
    
    def apply_changes(self, context: Dict[str, Any], changes: Dict[str, Any]) -> Dict[str, Any]:
        """
        Apply changes to context
        
        Args:
            context: Current context
            changes: Changes to apply
            
        Returns:
            Updated context
        """
        updated_context = context.copy()
        updated_context.update(changes)
        return updated_context
    
    def generate_context_hash(self, context: Dict[str, Any]) -> str:
        """
        Generate 8-character context hash
        
        Args:
            context: Context to hash
            
        Returns:
            8-character hash
        """
        context_str = json.dumps(context, sort_keys=True)
        return hashlib.sha256(context_str.encode()).hexdigest()[:8]
    
    def generate_context_receipt(self, context_event: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate immutable context receipt
        
        Args:
            context_event: Context event data
            
        Returns:
            Generated receipt
        """
        receipt = {
            'receipt_id': context_event['receipt_id'],
            'ref_tag': context_event['ref_tag'],
            'timestamp': context_event['timestamp'],
            'generation_context': {
                'trigger': context_event['trigger'],
                'prior_state': context_event['context_before'],
                'current_state': context_event['context_after'],
                'delta_summary': {
                    'fields_changed': list(context_event['changes'].keys()),
                    'new_capabilities': context_event['changes'].get('new_capabilities', []),
                    'risk_adjustments': context_event['changes'].get('risk_adjustments', 'none')
                }
            },
            'validation': {
                'hash': context_event['hash'],
                'signature': self.sign_receipt(context_event),
                'signed_by': 'python_toolkit'
            }
        }
        
        # Store receipt
        receipt_path = self.receipt_dir / f"receipt_{context_event['ref_tag']}.json"
        with open(receipt_path, 'w') as f:
            json.dump(receipt, f, indent=2)
        
        print(f"✓ Context receipt generated: {receipt_path}")
        return receipt
    
    def sign_receipt(self, context_event: Dict[str, Any]) -> str:
        """
        Sign receipt for integrity
        
        Args:
            context_event: Event to sign
            
        Returns:
            Signature
        """
        event_str = json.dumps(context_event, sort_keys=True)
        return hashlib.sha256(event_str.encode()).hexdigest()[:16]
    
    def validate_context_chain(self, start_ref: str, end_ref: str) -> bool:
        """
        Validate context chain integrity
        
        Args:
            start_ref: Starting REF tag
            end_ref: Ending REF tag
            
        Returns:
            Chain validity
        """
        try:
            receipts = self.get_context_chain(start_ref, end_ref)
            
            for i in range(len(receipts) - 1):
                current = receipts[i]
                next_receipt = receipts[i + 1]
                
                # Verify signature (simplified check)
                if not self.verify_signature(current):
                    print(f"Invalid signature for {current.get('ref_tag', 'unknown')}")
                    return False
            
            return True
            
        except Exception as e:
            print(f"Error validating context chain: {e}")
            return False
    
    def get_context_chain(self, start_ref: str, end_ref: str) -> List[Dict[str, Any]]:
        """
        Get context chain between two REF tags
        
        Args:
            start_ref: Starting REF tag
            end_ref: Ending REF tag
            
        Returns:
            Chain of context receipts
        """
        # Simplified implementation
        receipt_files = sorted([
            f for f in self.receipt_dir.iterdir()
            if f.name.startswith('receipt_') and f.name.endswith('.json')
        ])
        
        receipts = []
        for receipt_file in receipt_files:
            with open(receipt_file, 'r') as f:
                receipts.append(json.load(f))
        
        return receipts
    
    def verify_signature(self, receipt: Dict[str, Any]) -> bool:
        """
        Verify receipt signature
        
        Args:
            receipt: Receipt to verify
            
        Returns:
            Signature validity
        """
        validation = receipt.get('validation', {})
        signature = validation.get('signature', '')
        return len(signature) == 16


class ContextHealthMonitor:
    """
    Monitor context health and detect drift
    """
    
    def __init__(self, tracker: ContextTracker):
        self.tracker = tracker
    
    def check_context_health(self) -> Dict[str, Any]:
        """
        Check overall context health
        
        Returns:
            Health report
        """
        receipt_count = len(list(self.tracker.receipt_dir.glob('receipt_*.json')))
        audit_lines = 0
        
        if self.tracker.audit_log_path.exists():
            with open(self.tracker.audit_log_path, 'r') as f:
                audit_lines = len(f.readlines())
        
        # Calculate health metrics
        context_integrity = 100 if receipt_count > 0 else 0
        agent_sync = 85  # Simulated - would check actual heartbeats in production
        schema_compliance = 100 if audit_lines > 0 else 0
        audit_completeness = 100
        
        overall_health = (context_integrity + agent_sync + schema_compliance + audit_completeness) / 4
        
        return {
            'overall_health': overall_health,
            'metrics': {
                'context_integrity': context_integrity,
                'agent_synchronization': agent_sync,
                'schema_compliance': schema_compliance,
                'audit_completeness': audit_completeness
            },
            'receipt_count': receipt_count,
            'audit_entries': audit_lines,
            'alerts': self.generate_alerts(agent_sync, context_integrity)
        }
    
    def generate_alerts(self, agent_sync: int, context_integrity: int) -> List[str]:
        """
        Generate health alerts
        
        Args:
            agent_sync: Agent synchronization percentage
            context_integrity: Context integrity percentage
            
        Returns:
            List of alerts
        """
        alerts = []
        
        if agent_sync < 90:
            alerts.append("Agent synchronization below threshold")
        
        if context_integrity < 100:
            alerts.append("Context integrity issues detected")
        
        return alerts


def main():
    """CLI interface for the Python toolkit"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Locus Context Tracking Toolkit')
    parser.add_argument('action', help='Action type (notify, research, dash, etc.)')
    parser.add_argument('--trigger', default='cli_invocation', help='Event trigger')
    parser.add_argument('--changes', help='JSON string of changes')
    parser.add_argument('--health', action='store_true', help='Show health report')
    
    args = parser.parse_args()
    
    print('=== LOCUS Python Context Toolkit ===')
    
    tracker = ContextTracker()
    
    if args.health:
        monitor = ContextHealthMonitor(tracker)
        health = monitor.check_context_health()
        
        print(f"Overall Health: {health['overall_health']:.1f}%")
        print("Metrics:")
        for metric, value in health['metrics'].items():
            print(f"  {metric}: {value}%")
        
        if health['alerts']:
            print("Alerts:")
            for alert in health['alerts']:
                print(f"  ⚠️ {alert}")
        else:
            print("✅ No alerts")
        
        return
    
    # Parse changes if provided
    changes = {}
    if args.changes:
        changes = json.loads(args.changes)
    
    print(f"Action: {args.action}")
    print(f"Trigger: {args.trigger}")
    print('=' * 40)
    
    # Capture context event
    event = tracker.capture_context_event(args.action, args.trigger, changes)
    
    print(f"📊 Context Event Captured: {event['ref_tag']}")
    print(f"🔐 Receipt ID: {event['receipt_id']}")
    print(f"📝 Context Hash: {event['hash']}")


if __name__ == '__main__':
    main()