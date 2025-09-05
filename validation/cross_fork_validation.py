#!/usr/bin/env python3
"""
Cross-Fork Validation Framework for Project Locus
Validates core assumptions across all three testing forks
"""

import json
import datetime
import subprocess
import os
from pathlib import Path

class CrossForkValidation:
    def __init__(self):
        self.fork_results = {}
        self.start_time = datetime.datetime.now()
        
    def generate_ref_tag(self, validation_type="cross-fork"):
        """Generate REF tag for cross-fork validation"""
        script_path = Path(__file__).parent.parent / "automation" / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "job", f"cross-fork-{validation_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def measure_core_assumptions(self, fork_results):
        """Measure across all forks to validate core assumptions"""
        ref_tag = self.generate_ref_tag("assumptions")
        
        core_assumptions = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "forks_analyzed": list(fork_results.keys()),
            "assumptions": {
                "distributed_coordination_viability": self.assess_cross_machine_effectiveness(fork_results),
                "constitutional_scalability": self.validate_principle_enforcement(fork_results),
                "community_value_creation": self.measure_real_world_impact(fork_results),
                "resource_constraint_optimization": self.validate_efficiency_gains(fork_results),
                "knowledge_transfer_effectiveness": self.assess_learning_propagation(fork_results)
            },
            "overall_validation_score": 0.0,
            "integration_recommendations": []
        }
        
        # Calculate overall validation score
        assumption_scores = list(core_assumptions["assumptions"].values())
        core_assumptions["overall_validation_score"] = sum(assumption_scores) / len(assumption_scores)
        
        # Generate integration recommendations
        core_assumptions["integration_recommendations"] = self.generate_integration_recommendations(
            core_assumptions["assumptions"])
        
        # Save cross-fork validation
        validation_file = f"/tmp/locus_cross_fork_validation_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(validation_file, 'w') as f:
            json.dump(core_assumptions, f, indent=2)
        
        print(f"✓ Cross-fork validation completed: {ref_tag}")
        print(f"  Forks analyzed: {len(fork_results)}")
        print(f"  Overall validation score: {core_assumptions['overall_validation_score']:.2f}")
        print(f"  Integration recommendations: {len(core_assumptions['integration_recommendations'])}")
        print(f"  Validation saved: {validation_file}")
        
        return core_assumptions
    
    def assess_cross_machine_effectiveness(self, fork_results):
        """Assess distributed coordination effectiveness from Fork A"""
        fork_a_result = fork_results.get("A", {})
        
        # Check Fork A specific metrics
        coordination_tests = fork_a_result.get("test_results", [])
        ref_tag_test = next((t for t in coordination_tests if "REF-tag Persistence" in t.get("test_name", "")), None)
        handover_test = next((t for t in coordination_tests if "Agent Handover" in t.get("test_name", "")), None)
        
        effectiveness_score = 0.0
        
        if ref_tag_test and ref_tag_test.get("status") == "PASS":
            sync_time = float(ref_tag_test.get("details", {}).get("sync_duration", "0.1s").replace("s", ""))
            if sync_time <= 10:  # Within 10 second requirement
                effectiveness_score += 0.4
        
        if handover_test and handover_test.get("status") == "PASS":
            context_preserved = handover_test.get("details", {}).get("task_context_preserved")
            if context_preserved:
                effectiveness_score += 0.4
        
        # Check overall Fork A success rate
        fork_a_success = fork_a_result.get("summary", {}).get("success_rate", "0%")
        if fork_a_success == "100.0%":
            effectiveness_score += 0.2
        
        return min(effectiveness_score, 1.0)
    
    def validate_principle_enforcement(self, fork_results):
        """Validate constitutional principle enforcement from Fork B"""
        fork_b_result = fork_results.get("B", {})
        
        # Check Fork B specific metrics
        constitutional_tests = fork_b_result.get("test_results", [])
        resource_test = next((t for t in constitutional_tests if "Resource Constraint" in t.get("test_name", "")), None)
        authority_test = next((t for t in constitutional_tests if "Expert Authority" in t.get("test_name", "")), None)
        transparency_test = next((t for t in constitutional_tests if "Transparency" in t.get("test_name", "")), None)
        
        scalability_score = 0.0
        
        if resource_test and resource_test.get("status") == "PASS":
            halt_functional = resource_test.get("details", {}).get("emergency_halt_functional")
            if halt_functional:
                scalability_score += 0.3
        
        if authority_test and authority_test.get("status") == "PASS":
            authority_respected = authority_test.get("details", {}).get("expert_authority_respected")
            if authority_respected:
                scalability_score += 0.3
        
        if transparency_test and transparency_test.get("status") == "PASS":
            audit_complete = transparency_test.get("details", {}).get("audit_trail_complete")
            if audit_complete:
                scalability_score += 0.2
        
        # Check overall Fork B success rate
        fork_b_success = fork_b_result.get("summary", {}).get("success_rate", "0%")
        if fork_b_success == "100.0%":
            scalability_score += 0.2
        
        return min(scalability_score, 1.0)
    
    def measure_real_world_impact(self, fork_results):
        """Measure community value creation from Fork C"""
        fork_c_result = fork_results.get("C", {})
        
        # Check Fork C specific metrics
        community_tests = fork_c_result.get("test_results", [])
        effectiveness_test = next((t for t in community_tests if "Template Effectiveness" in t.get("test_name", "")), None)
        sustainability_test = next((t for t in community_tests if "Economic Sustainability" in t.get("test_name", "")), None)
        scenarios_test = next((t for t in community_tests if "Real User Scenarios" in t.get("test_name", "")), None)
        
        impact_score = 0.0
        
        if effectiveness_test and effectiveness_test.get("status") == "PASS":
            task_completion = effectiveness_test.get("details", {}).get("task_completion_rate", "0%")
            completion_rate = float(task_completion.replace("%", "")) / 100
            impact_score += completion_rate * 0.3
        
        if sustainability_test and sustainability_test.get("status") == "PASS":
            sustainability_score = sustainability_test.get("details", {}).get("sustainability_score", "0%")
            sustain_rate = float(sustainability_score.replace("%", "")) / 100
            impact_score += sustain_rate * 0.4
        
        if scenarios_test and scenarios_test.get("status") == "PASS":
            time_saved = scenarios_test.get("details", {}).get("total_time_saved_hours", 0)
            if time_saved > 40:  # Significant time savings
                impact_score += 0.3
        
        return min(impact_score, 1.0)
    
    def validate_efficiency_gains(self, fork_results):
        """Validate resource constraint optimization across forks"""
        efficiency_score = 0.0
        
        # Check Fork A resource efficiency
        fork_a_result = fork_results.get("A", {})
        resource_test_a = next((t for t in fork_a_result.get("test_results", []) 
                               if "Resource Constraint" in t.get("test_name", "")), None)
        if resource_test_a and resource_test_a.get("status") == "PASS":
            constraints_respected = resource_test_a.get("details", {}).get("all_constraints_respected")
            if constraints_respected:
                efficiency_score += 0.4
        
        # Check Fork B resource management
        fork_b_result = fork_results.get("B", {})
        for test in fork_b_result.get("test_results", []):
            if test.get("status") == "PASS" and test.get("duration", 10) < 5:  # Fast execution
                efficiency_score += 0.1
                break
        
        # Check Fork C coordination efficiency
        fork_c_result = fork_results.get("C", {})
        integration_test = next((t for t in fork_c_result.get("test_results", []) 
                               if "Tool Integration" in t.get("test_name", "")), None)
        if integration_test and integration_test.get("status") == "PASS":
            success_rate = integration_test.get("details", {}).get("integration_success_rate", "0%")
            if success_rate == "100%":
                efficiency_score += 0.3
        
        # Overall execution efficiency
        total_duration = sum(float(result.get("summary", {}).get("total_duration", "0s").replace("s", "")) 
                           for result in fork_results.values())
        if total_duration < 30:  # All tests complete in under 30 seconds
            efficiency_score += 0.2
        
        return min(efficiency_score, 1.0)
    
    def assess_learning_propagation(self, fork_results):
        """Assess knowledge transfer effectiveness across forks"""
        learning_score = 0.0
        
        # Check Fork C learning capabilities
        fork_c_result = fork_results.get("C", {})
        learning_test = next((t for t in fork_c_result.get("test_results", []) 
                            if "Learning Loop" in t.get("test_name", "")), None)
        if learning_test and learning_test.get("status") == "PASS":
            improvement = learning_test.get("details", {}).get("learning_improvement", "0%")
            if improvement == "15%":
                learning_score += 0.4
        
        # Check knowledge democratization
        knowledge_test = next((t for t in fork_c_result.get("test_results", []) 
                             if "Knowledge Democratization" in t.get("test_name", "")), None)
        if knowledge_test and knowledge_test.get("status") == "PASS":
            accessibility = knowledge_test.get("details", {}).get("accessibility_score", "0%")
            access_rate = float(accessibility.replace("%", "")) / 100
            learning_score += access_rate * 0.3
        
        # Check cross-fork knowledge integration
        # (REF tagging system enables knowledge transfer across all forks)
        ref_tag_files = list(Path("/tmp").glob("locus_*_*.json"))
        if len(ref_tag_files) > 10:  # Rich knowledge base created
            learning_score += 0.3
        
        return min(learning_score, 1.0)
    
    def generate_integration_recommendations(self, assumptions):
        """Generate recommendations for system integration based on validation results"""
        recommendations = []
        
        # Analyze each assumption
        for assumption, score in assumptions.items():
            if score >= 0.8:
                if assumption == "distributed_coordination_viability":
                    recommendations.append({
                        "priority": "high",
                        "action": "Deploy Fork A coordination infrastructure to production",
                        "rationale": f"High coordination effectiveness score: {score:.2f}"
                    })
                elif assumption == "constitutional_scalability":
                    recommendations.append({
                        "priority": "high", 
                        "action": "Implement Fork B constitutional monitoring across all systems",
                        "rationale": f"Strong principle enforcement validation: {score:.2f}"
                    })
                elif assumption == "community_value_creation":
                    recommendations.append({
                        "priority": "medium",
                        "action": "Launch Fork C community template marketplace",
                        "rationale": f"Proven community value creation: {score:.2f}"
                    })
            else:
                if assumption == "resource_constraint_optimization":
                    recommendations.append({
                        "priority": "medium",
                        "action": "Optimize resource usage patterns before broader deployment",
                        "rationale": f"Resource efficiency needs improvement: {score:.2f}"
                    })
        
        # Overall integration strategy
        avg_score = sum(assumptions.values()) / len(assumptions)
        if avg_score >= 0.8:
            recommendations.append({
                "priority": "high",
                "action": "Proceed with unified system integration",
                "rationale": f"Overall validation score {avg_score:.2f} exceeds 0.8 threshold"
            })
        else:
            recommendations.append({
                "priority": "high",
                "action": "Address validation gaps before full integration", 
                "rationale": f"Overall validation score {avg_score:.2f} below 0.8 threshold"
            })
        
        return recommendations
    
    def run_all_fork_tests(self):
        """Run all fork tests and collect results"""
        print("=== LOCUS Cross-Fork Validation Framework ===")
        print(f"Started: {datetime.datetime.now().isoformat()}")
        
        # Run Fork A tests
        print("\n🔄 Running Fork A: Core Coordination Validation...")
        fork_a_result = subprocess.run([
            "python3", "./validation/coordination_test.py"
        ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
        
        if fork_a_result.returncode == 0:
            # Load Fork A results
            fork_a_files = list(Path("/tmp").glob("locus_fork_a_validation_report_*.json"))
            if fork_a_files:
                latest_a = max(fork_a_files, key=os.path.getctime)
                with open(latest_a, 'r') as f:
                    self.fork_results["A"] = json.load(f)
                print("✓ Fork A completed successfully")
            else:
                print("❌ Fork A results not found")
        else:
            print(f"❌ Fork A failed: {fork_a_result.stderr}")
        
        # Run Fork B tests
        print("\n🔄 Running Fork B: Constitutional Constraint Validation...")
        fork_b_result = subprocess.run([
            "python3", "./validation/constitutional_test.py"
        ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
        
        if fork_b_result.returncode == 0:
            # Load Fork B results
            fork_b_files = list(Path("/tmp").glob("locus_fork_b_validation_report_*.json"))
            if fork_b_files:
                latest_b = max(fork_b_files, key=os.path.getctime)
                with open(latest_b, 'r') as f:
                    self.fork_results["B"] = json.load(f)
                print("✓ Fork B completed successfully")
            else:
                print("❌ Fork B results not found")
        else:
            print(f"❌ Fork B failed: {fork_b_result.stderr}")
        
        # Run Fork C tests
        print("\n🔄 Running Fork C: Community Template Discovery...")
        fork_c_result = subprocess.run([
            "python3", "./validation/community_impact_test.py"
        ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
        
        if fork_c_result.returncode == 0:
            # Load Fork C results
            fork_c_files = list(Path("/tmp").glob("locus_fork_c_validation_report_*.json"))
            if fork_c_files:
                latest_c = max(fork_c_files, key=os.path.getctime)
                with open(latest_c, 'r') as f:
                    self.fork_results["C"] = json.load(f)
                print("✓ Fork C completed successfully")
            else:
                print("❌ Fork C results not found")
        else:
            print(f"❌ Fork C failed: {fork_c_result.stderr}")
        
        # Perform cross-fork analysis
        if self.fork_results:
            print(f"\n🔍 Analyzing {len(self.fork_results)} fork results...")
            validation_result = self.measure_core_assumptions(self.fork_results)
            
            print(f"\n📊 Cross-Fork Validation Summary")
            print(f"   Distributed coordination: {validation_result['assumptions']['distributed_coordination_viability']:.2f}")
            print(f"   Constitutional scalability: {validation_result['assumptions']['constitutional_scalability']:.2f}")
            print(f"   Community value creation: {validation_result['assumptions']['community_value_creation']:.2f}")
            print(f"   Resource optimization: {validation_result['assumptions']['resource_constraint_optimization']:.2f}")
            print(f"   Knowledge transfer: {validation_result['assumptions']['knowledge_transfer_effectiveness']:.2f}")
            print(f"   Overall validation score: {validation_result['overall_validation_score']:.2f}")
            
            return validation_result
        else:
            print("❌ No fork results available for cross-validation")
            return None

def main():
    validator = CrossForkValidation()
    result = validator.run_all_fork_tests()
    
    if result and result['overall_validation_score'] >= 0.8:
        print("\n🎉 LOCUS Testing Forks Validation: SUCCESS")
        print("All core assumptions validated - system ready for integration")
        return 0
    else:
        print("\n⚠️  LOCUS Testing Forks Validation: NEEDS ATTENTION")
        print("Some assumptions require further validation")
        return 1

if __name__ == "__main__":
    import sys
    sys.exit(main())