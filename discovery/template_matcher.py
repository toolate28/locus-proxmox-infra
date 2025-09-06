#!/usr/bin/env python3
"""
Template Matcher for Project Locus Fork C
Matches user needs to appropriate community templates
"""

import json
import os
import datetime
import subprocess
from pathlib import Path

class TemplateMatcher:
    def __init__(self, templates_dir="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra/templates"):
        self.templates_dir = Path(templates_dir)
        self.templates = self._load_templates()
        
    def generate_ref_tag(self, match_type="match"):
        """Generate REF tag for template matching"""
        script_path = Path(__file__).parent.parent / "automation" / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "job", f"template-{match_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def _load_templates(self):
        """Load all available templates"""
        templates = {}
        
        for template_dir in self.templates_dir.iterdir():
            if template_dir.is_dir():
                config_file = template_dir / "template_config.json"
                if config_file.exists():
                    try:
                        with open(config_file, 'r') as f:
                            template_config = json.load(f)
                        templates[template_dir.name] = template_config
                    except (json.JSONDecodeError, Exception) as e:
                        print(f"Warning: Could not load template {template_dir.name}: {e}")
        
        return templates
    
    def match_user_needs(self, user_profile, requirements=None):
        """Match user profile to most suitable templates"""
        ref_tag = self.generate_ref_tag("user-needs")
        
        matches = []
        
        for template_name, template_config in self.templates.items():
            score = self._calculate_match_score(user_profile, template_config, requirements)
            
            if score > 0:
                matches.append({
                    "template_name": template_name,
                    "template_ref": template_config.get("ref_tag"),
                    "match_score": score,
                    "use_case": template_config.get("use_case"),
                    "target_users": template_config.get("target_users", []),
                    "workflow_steps": len(template_config.get("workflow_steps", [])),
                    "tool_integrations": len(template_config.get("tool_integrations", {}).get("existing_tools", []))
                })
        
        # Sort by match score (descending)
        matches.sort(key=lambda x: x["match_score"], reverse=True)
        
        # Create matching record
        match_record = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "user_profile": user_profile,
            "requirements": requirements or {},
            "matches": matches,
            "top_match": matches[0] if matches else None,
            "total_templates_evaluated": len(self.templates)
        }
        
        # Save matching record
        match_file = f"/tmp/locus_template_match_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(match_file, 'w') as f:
            json.dump(match_record, f, indent=2)
            
        print(f"✓ Template matching completed: {ref_tag}")
        print(f"  User profile: {user_profile.get('user_type', 'unknown')}")
        print(f"  Templates evaluated: {len(self.templates)}")
        print(f"  Matches found: {len(matches)}")
        if matches:
            print(f"  Top match: {matches[0]['template_name']} (score: {matches[0]['match_score']:.2f})")
        print(f"  Match record: {match_file}")
        
        return match_record
    
    def _calculate_match_score(self, user_profile, template_config, requirements):
        """Calculate match score between user profile and template"""
        score = 0.0
        
        # Check user type alignment
        user_type = user_profile.get("user_type", "").lower()
        target_users = [u.lower() for u in template_config.get("target_users", [])]
        
        for target in target_users:
            if user_type in target or target in user_type:
                score += 1.0
                break
        else:
            # Partial match for related user types
            if ("parent" in user_type and any("parent" in t for t in target_users)) or \
               ("builder" in user_type and any("contractor" in t or "construction" in t for t in target_users)) or \
               ("community" in user_type and any("community" in t or "organization" in t for t in target_users)):
                score += 0.5
        
        # Check use case alignment
        use_case = template_config.get("use_case", "").lower()
        user_needs = user_profile.get("primary_needs", [])
        
        for need in user_needs:
            if need.lower() in use_case:
                score += 0.5
        
        # Check tool preferences
        existing_tools = template_config.get("tool_integrations", {}).get("existing_tools", [])
        user_tools = user_profile.get("current_tools", [])
        
        tool_overlap = len(set(tool.lower() for tool in user_tools) & 
                          set(tool.lower() for tool in existing_tools))
        score += tool_overlap * 0.3
        
        # Check complexity preference
        workflow_complexity = len(template_config.get("workflow_steps", []))
        user_complexity_pref = user_profile.get("complexity_preference", "medium")
        
        if user_complexity_pref == "simple" and workflow_complexity <= 3:
            score += 0.3
        elif user_complexity_pref == "medium" and 3 < workflow_complexity <= 5:
            score += 0.3
        elif user_complexity_pref == "complex" and workflow_complexity > 5:
            score += 0.3
        
        # Requirements matching
        if requirements:
            for req_key, req_value in requirements.items():
                template_value = template_config.get(req_key)
                if template_value and str(req_value).lower() in str(template_value).lower():
                    score += 0.2
        
        return score
    
    def get_template_details(self, template_name):
        """Get detailed information about a specific template"""
        if template_name not in self.templates:
            print(f"❌ Template not found: {template_name}")
            return None
            
        template_config = self.templates[template_name]
        template_dir = self.templates_dir / template_name
        
        # Get template files
        template_files = []
        if template_dir.exists():
            for file_path in template_dir.rglob("*"):
                if file_path.is_file() and file_path.name != "template_config.json":
                    template_files.append(str(file_path.relative_to(template_dir)))
        
        details = {
            "template_name": template_name,
            "config": template_config,
            "available_files": template_files,
            "directory": str(template_dir)
        }
        
        print(f"✓ Template details retrieved: {template_name}")
        print(f"  REF: {template_config.get('ref_tag')}")
        print(f"  Use case: {template_config.get('use_case')}")
        print(f"  Workflow steps: {len(template_config.get('workflow_steps', []))}")
        print(f"  Available files: {len(template_files)}")
        
        return details
    
    def list_all_templates(self):
        """List all available templates with summary information"""
        print("=== Available Community Templates ===")
        
        for template_name, template_config in self.templates.items():
            print(f"\n📋 {template_name}")
            print(f"   REF: {template_config.get('ref_tag')}")
            print(f"   Type: {template_config.get('template_type')}")
            print(f"   Target users: {', '.join(template_config.get('target_users', []))}")
            print(f"   Workflow steps: {len(template_config.get('workflow_steps', []))}")
            print(f"   Tool integrations: {len(template_config.get('tool_integrations', {}).get('existing_tools', []))}")
        
        print(f"\nTotal templates: {len(self.templates)}")
        
        return self.templates

def main():
    import sys
    
    matcher = TemplateMatcher()
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 template_matcher.py list")
        print("  python3 template_matcher.py match <user_type> [needs...]")
        print("  python3 template_matcher.py details <template_name>")
        print("")
        print("Examples:")
        print("  python3 template_matcher.py list")
        print("  python3 template_matcher.py match single_parent scheduling budgeting")
        print("  python3 template_matcher.py details household_management")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "list":
        matcher.list_all_templates()
        
    elif command == "match":
        if len(sys.argv) < 3:
            print("Error: match requires user_type")
            sys.exit(1)
            
        user_type = sys.argv[2]
        needs = sys.argv[3:] if len(sys.argv) > 3 else []
        
        user_profile = {
            "user_type": user_type,
            "primary_needs": needs,
            "current_tools": ["gmail", "google_calendar", "smartphone"],
            "complexity_preference": "medium"
        }
        
        match_result = matcher.match_user_needs(user_profile)
        
        if match_result["matches"]:
            print(f"\n🎯 Top recommendation: {match_result['top_match']['template_name']}")
            print(f"   Match score: {match_result['top_match']['match_score']:.2f}")
            print(f"   Use case: {match_result['top_match']['use_case']}")
        else:
            print("No suitable templates found for the given profile")
            
    elif command == "details":
        if len(sys.argv) < 3:
            print("Error: details requires template_name")
            sys.exit(1)
            
        template_name = sys.argv[2]
        details = matcher.get_template_details(template_name)
        
        if details:
            print(json.dumps(details["config"], indent=2))
            
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()