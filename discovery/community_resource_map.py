#!/usr/bin/env python3
"""
Community Resource Map for Project Locus Fork C
Maps template needs to existing community tools and services
"""

import json
import datetime
import subprocess
from pathlib import Path

class CommunityResourceMap:
    def __init__(self):
        self.resource_database = self._load_resource_database()
        
    def generate_ref_tag(self, resource_type="resource"):
        """Generate REF tag for resource mapping"""
        script_path = Path(__file__).parent.parent / "automation" / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "job", f"resource-{resource_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def _load_resource_database(self):
        """Load community resource database"""
        return {
            "productivity_tools": {
                "scheduling": [
                    {"name": "Google Calendar", "type": "free", "integration": "api", "use_cases": ["family_scheduling", "event_planning"]},
                    {"name": "Calendly", "type": "freemium", "integration": "api", "use_cases": ["appointment_booking", "service_scheduling"]},
                    {"name": "Doodle", "type": "freemium", "integration": "api", "use_cases": ["group_scheduling", "meeting_coordination"]}
                ],
                "communication": [
                    {"name": "Slack", "type": "freemium", "integration": "api", "use_cases": ["team_communication", "project_coordination"]},
                    {"name": "Discord", "type": "free", "integration": "api", "use_cases": ["community_chat", "group_coordination"]},
                    {"name": "WhatsApp Business", "type": "free", "integration": "api", "use_cases": ["client_communication", "group_messaging"]}
                ],
                "project_management": [
                    {"name": "Trello", "type": "freemium", "integration": "api", "use_cases": ["task_management", "project_tracking"]},
                    {"name": "Asana", "type": "freemium", "integration": "api", "use_cases": ["team_collaboration", "workflow_management"]},
                    {"name": "Notion", "type": "freemium", "integration": "api", "use_cases": ["documentation", "knowledge_management"]}
                ]
            },
            "financial_tools": {
                "budgeting": [
                    {"name": "Mint", "type": "free", "integration": "api", "use_cases": ["personal_budgeting", "expense_tracking"]},
                    {"name": "YNAB", "type": "paid", "integration": "api", "use_cases": ["advanced_budgeting", "financial_planning"]},
                    {"name": "QuickBooks", "type": "paid", "integration": "api", "use_cases": ["business_accounting", "invoicing"]}
                ],
                "payments": [
                    {"name": "Square", "type": "transaction_fee", "integration": "api", "use_cases": ["payment_processing", "invoicing"]},
                    {"name": "PayPal", "type": "transaction_fee", "integration": "api", "use_cases": ["online_payments", "money_transfer"]},
                    {"name": "Venmo", "type": "free", "integration": "api", "use_cases": ["peer_payments", "expense_splitting"]}
                ]
            },
            "community_tools": {
                "event_management": [
                    {"name": "Eventbrite", "type": "transaction_fee", "integration": "api", "use_cases": ["event_registration", "ticket_sales"]},
                    {"name": "Meetup", "type": "subscription", "integration": "api", "use_cases": ["community_events", "group_organization"]},
                    {"name": "Facebook Events", "type": "free", "integration": "api", "use_cases": ["social_events", "community_engagement"]}
                ],
                "volunteer_coordination": [
                    {"name": "SignUpGenius", "type": "freemium", "integration": "api", "use_cases": ["volunteer_scheduling", "resource_coordination"]},
                    {"name": "VolunteerUp", "type": "paid", "integration": "api", "use_cases": ["volunteer_management", "hour_tracking"]},
                    {"name": "JustServe", "type": "free", "integration": "limited", "use_cases": ["volunteer_opportunities", "community_service"]}
                ]
            },
            "specialized_tools": {
                "construction": [
                    {"name": "Home Depot Pro", "type": "free", "integration": "api", "use_cases": ["material_ordering", "project_tracking"]},
                    {"name": "Lowe's Pro", "type": "free", "integration": "api", "use_cases": ["material_purchasing", "delivery_scheduling"]},
                    {"name": "BuilderTREND", "type": "paid", "integration": "api", "use_cases": ["construction_management", "client_communication"]}
                ],
                "household": [
                    {"name": "Cozi", "type": "freemium", "integration": "api", "use_cases": ["family_organization", "shared_calendars"]},
                    {"name": "AnyList", "type": "freemium", "integration": "api", "use_cases": ["shopping_lists", "meal_planning"]},
                    {"name": "Tody", "type": "paid", "integration": "limited", "use_cases": ["cleaning_schedules", "household_maintenance"]}
                ]
            }
        }
    
    def map_template_to_resources(self, template_name, template_config):
        """Map a template to relevant community resources"""
        ref_tag = self.generate_ref_tag("mapping")
        
        template_type = template_config.get("template_type", "")
        workflow_steps = template_config.get("workflow_steps", [])
        existing_integrations = template_config.get("tool_integrations", {}).get("existing_tools", [])
        
        resource_mapping = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "template_name": template_name,
            "template_ref": template_config.get("ref_tag"),
            "mapped_resources": [],
            "integration_opportunities": [],
            "cost_analysis": {"free": 0, "freemium": 0, "paid": 0, "transaction_fee": 0},
            "coverage_score": 0.0
        }
        
        # Analyze workflow steps and map to resources
        for step in workflow_steps:
            step_tools = step.get("tools", [])
            step_resources = self._find_resources_for_step(step, template_type)
            
            for resource in step_resources:
                resource_mapping["mapped_resources"].append({
                    "workflow_step": step.get("name"),
                    "resource_name": resource["name"],
                    "resource_type": resource["type"],
                    "integration_level": resource["integration"],
                    "use_cases": resource["use_cases"],
                    "already_integrated": resource["name"] in [tool.split("(")[0].strip() for tool in existing_integrations]
                })
                
                # Update cost analysis
                resource_mapping["cost_analysis"][resource["type"]] += 1
        
        # Calculate coverage score
        total_steps = len(workflow_steps)
        covered_steps = len(set(r["workflow_step"] for r in resource_mapping["mapped_resources"]))
        resource_mapping["coverage_score"] = (covered_steps / total_steps) if total_steps > 0 else 0.0
        
        # Identify integration opportunities
        resource_mapping["integration_opportunities"] = self._identify_integration_opportunities(
            resource_mapping["mapped_resources"], existing_integrations)
        
        # Save mapping record
        mapping_file = f"/tmp/locus_resource_mapping_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(mapping_file, 'w') as f:
            json.dump(resource_mapping, f, indent=2)
        
        print(f"✓ Resource mapping completed: {ref_tag}")
        print(f"  Template: {template_name}")
        print(f"  Resources identified: {len(resource_mapping['mapped_resources'])}")
        print(f"  Coverage score: {resource_mapping['coverage_score']:.2f}")
        print(f"  Integration opportunities: {len(resource_mapping['integration_opportunities'])}")
        print(f"  Mapping record: {mapping_file}")
        
        return resource_mapping
    
    def _find_resources_for_step(self, step, template_type):
        """Find relevant resources for a workflow step"""
        step_name = step.get("name", "").lower()
        step_tools = step.get("tools", [])
        resources = []
        
        # Map step requirements to resource categories
        if any(tool in ["calendar", "schedule", "appointment"] for tool in step_tools):
            resources.extend(self.resource_database["productivity_tools"]["scheduling"])
        
        if any(tool in ["communication", "messaging", "notification"] for tool in step_tools):
            resources.extend(self.resource_database["productivity_tools"]["communication"])
        
        if any(tool in ["project", "task", "tracking"] for tool in step_tools):
            resources.extend(self.resource_database["productivity_tools"]["project_management"])
        
        if any(tool in ["budget", "expense", "financial"] for tool in step_tools):
            resources.extend(self.resource_database["financial_tools"]["budgeting"])
        
        if any(tool in ["payment", "invoice", "billing"] for tool in step_tools):
            resources.extend(self.resource_database["financial_tools"]["payments"])
        
        if any(tool in ["event", "meeting", "coordination"] for tool in step_tools):
            resources.extend(self.resource_database["community_tools"]["event_management"])
        
        if any(tool in ["volunteer", "signup", "coordination"] for tool in step_tools):
            resources.extend(self.resource_database["community_tools"]["volunteer_coordination"])
        
        # Template-specific resource mapping
        if template_type == "builder_expense_tracking":
            resources.extend(self.resource_database["specialized_tools"]["construction"])
        elif template_type == "household_management":
            resources.extend(self.resource_database["specialized_tools"]["household"])
        
        # Remove duplicates
        unique_resources = []
        seen_names = set()
        for resource in resources:
            if resource["name"] not in seen_names:
                unique_resources.append(resource)
                seen_names.add(resource["name"])
        
        return unique_resources
    
    def _identify_integration_opportunities(self, mapped_resources, existing_integrations):
        """Identify new integration opportunities"""
        opportunities = []
        existing_tool_names = [tool.split("(")[0].strip() for tool in existing_integrations]
        
        for resource in mapped_resources:
            if (resource["resource_name"] not in existing_tool_names and 
                resource["integration_level"] == "api"):
                
                opportunities.append({
                    "tool_name": resource["resource_name"],
                    "integration_type": "new_api_connection",
                    "use_cases": resource["use_cases"],
                    "cost_type": resource["resource_type"],
                    "workflow_step": resource["workflow_step"]
                })
        
        return opportunities
    
    def analyze_community_ecosystem(self, template_configs):
        """Analyze the broader community ecosystem for multiple templates"""
        ref_tag = self.generate_ref_tag("ecosystem")
        
        ecosystem_analysis = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "templates_analyzed": len(template_configs),
            "total_resources": 0,
            "resource_overlap": {},
            "cost_distribution": {"free": 0, "freemium": 0, "paid": 0, "transaction_fee": 0},
            "integration_potential": 0,
            "community_value_score": 0.0
        }
        
        all_resources = []
        
        # Map each template to resources
        for template_name, template_config in template_configs.items():
            mapping = self.map_template_to_resources(template_name, template_config)
            all_resources.extend(mapping["mapped_resources"])
        
        # Analyze resource overlap
        resource_names = [r["resource_name"] for r in all_resources]
        for resource_name in set(resource_names):
            count = resource_names.count(resource_name)
            if count > 1:
                ecosystem_analysis["resource_overlap"][resource_name] = count
        
        # Calculate cost distribution
        for resource in all_resources:
            ecosystem_analysis["cost_distribution"][resource["resource_type"]] += 1
        
        ecosystem_analysis["total_resources"] = len(set(resource_names))
        ecosystem_analysis["integration_potential"] = len([r for r in all_resources if r["integration_level"] == "api"])
        
        # Calculate community value score
        overlap_score = len(ecosystem_analysis["resource_overlap"]) / max(len(set(resource_names)), 1)
        free_ratio = (ecosystem_analysis["cost_distribution"]["free"] + 
                     ecosystem_analysis["cost_distribution"]["freemium"]) / max(len(all_resources), 1)
        api_ratio = ecosystem_analysis["integration_potential"] / max(len(all_resources), 1)
        
        ecosystem_analysis["community_value_score"] = (overlap_score * 0.4 + free_ratio * 0.3 + api_ratio * 0.3)
        
        # Save ecosystem analysis
        analysis_file = f"/tmp/locus_ecosystem_analysis_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(analysis_file, 'w') as f:
            json.dump(ecosystem_analysis, f, indent=2)
        
        print(f"✓ Ecosystem analysis completed: {ref_tag}")
        print(f"  Templates analyzed: {ecosystem_analysis['templates_analyzed']}")
        print(f"  Unique resources: {ecosystem_analysis['total_resources']}")
        print(f"  Resource overlap opportunities: {len(ecosystem_analysis['resource_overlap'])}")
        print(f"  Community value score: {ecosystem_analysis['community_value_score']:.2f}")
        print(f"  Analysis saved: {analysis_file}")
        
        return ecosystem_analysis

def main():
    import sys
    
    resource_map = CommunityResourceMap()
    
    print("=== LOCUS Fork C: Community Resource Mapping ===")
    
    # For demonstration, analyze all available templates
    try:
        from template_matcher import TemplateMatcher
        matcher = TemplateMatcher()
        templates = matcher.templates
        
        if templates:
            print(f"Analyzing {len(templates)} community templates...")
            ecosystem_analysis = resource_map.analyze_community_ecosystem(templates)
            
            print(f"\n🌐 Community Ecosystem Analysis")
            print(f"   Total unique resources: {ecosystem_analysis['total_resources']}")
            print(f"   Resource sharing opportunities: {len(ecosystem_analysis['resource_overlap'])}")
            print(f"   API integration potential: {ecosystem_analysis['integration_potential']}")
            print(f"   Community value score: {ecosystem_analysis['community_value_score']:.2f}")
            
            if ecosystem_analysis['resource_overlap']:
                print(f"\n📊 Most valuable shared resources:")
                sorted_overlap = sorted(ecosystem_analysis['resource_overlap'].items(), 
                                      key=lambda x: x[1], reverse=True)
                for resource, count in sorted_overlap[:5]:
                    print(f"   - {resource}: used by {count} templates")
        else:
            print("No templates found to analyze")
            
    except ImportError:
        print("Template matcher not available - running standalone resource mapping")

if __name__ == "__main__":
    main()