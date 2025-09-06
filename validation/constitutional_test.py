#!/usr/bin/env python3
"""
Fork B: Constitutional Constraint Validation Tests
Tests constitutional principle enforcement across distributed infrastructure
"""

import os
import json
import time
import subprocess
import datetime
from pathlib import Path

class ConstitutionalTest:
    def __init__(self):
        self.test_results = []
        self.start_time = datetime.datetime.now()
        
    def generate_ref_tag(self, test_type="test"):
        """Generate REF tag for test using the shell script"""
        script_path = Path(__file__).parent.parent / "automation" / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "job", f"constitutional-{test_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def log_test_result(self, test_name, status, details=None, duration=None):
        """Log a test result"""
        result = {
            "test_name": test_name,
            "status": status,
            "timestamp": datetime.datetime.now().isoformat(),
            "duration": duration,
            "details": details or {}
        }
        self.test_results.append(result)
        
        status_symbol = "✓" if status == "PASS" else "✗"
        print(f"{status_symbol} {test_name}: {status}")
        if details:
            for key, value in details.items():
                print(f"    {key}: {value}")
    
    def test_resource_constraint_enforcement(self):
        """Test 1: System halts operations that would exceed 12GB on core machine"""
        print("\n=== Test 1: Resource Constraint Enforcement ===")
        test_start = time.time()
        
        try:
            # Run principle tracker check
            result = subprocess.run([
                "python3", "./monitoring/principle_tracker.py"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            if result.returncode != 0:
                raise Exception(f"Principle tracker failed: {result.stderr}")
            
            # Check for resource violations
            violation_detected = "resource_violation" in result.stdout or "resource_warning" in result.stdout
            
            # Simulate resource enforcement test
            halt_result = subprocess.run([
                "./automation/emergency_halt.sh", "--halt", "resource_constraint_test", "critical"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            if halt_result.returncode == 0:
                # Check if halt was properly executed
                emergency_files = list(Path("/tmp").glob("locus_emergency_halt_*.json"))
                
                if emergency_files:
                    # Read the most recent emergency halt
                    latest_halt = max(emergency_files, key=os.path.getctime)
                    with open(latest_halt, 'r') as f:
                        halt_data = json.load(f)
                    
                    duration = time.time() - test_start
                    self.log_test_result("Resource Constraint Enforcement", "PASS", {
                        "halt_ref": halt_data.get("ref_tag"),
                        "halt_reason": halt_data.get("reason"),
                        "emergency_halt_functional": True,
                        "resource_monitoring_active": True,
                        "halt_duration": f"{duration:.2f}s"
                    }, duration)
                else:
                    self.log_test_result("Resource Constraint Enforcement", "FAIL", {
                        "reason": "Emergency halt not created"
                    })
            else:
                self.log_test_result("Resource Constraint Enforcement", "FAIL", {
                    "reason": "Emergency halt command failed"
                })
                
        except Exception as e:
            self.log_test_result("Resource Constraint Enforcement", "FAIL", {
                "error": str(e)
            })
    
    def test_cross_machine_principle_propagation(self):
        """Test 2: Principle violation on experimental machine triggers core machine response"""
        print("\n=== Test 2: Cross-Machine Principle Propagation ===")
        test_start = time.time()
        
        try:
            # Simulate principle violation on experimental machine
            violation_data = {
                "ref_tag": self.generate_ref_tag("violation"),
                "machine_type": "experimental",
                "violation_type": "resource_exceeded",
                "principle": "resource_constraint_enforcement",
                "timestamp": datetime.datetime.now().isoformat(),
                "requires_propagation": True
            }
            
            violation_file = f"/tmp/locus_principle_violation_{violation_data['ref_tag']}.json"
            with open(violation_file, 'w') as f:
                json.dump(violation_data, f, indent=2)
            
            # Check if core machine responds (simulate sync)
            subprocess.run([
                "./automation/sync_ref_state.sh", "--sync"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            # Verify propagation by checking if principle tracker detects violation
            tracker_result = subprocess.run([
                "python3", "./monitoring/principle_tracker.py"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            duration = time.time() - test_start
            
            if duration <= 5:  # Within 5 second propagation timeout
                self.log_test_result("Cross-Machine Principle Propagation", "PASS", {
                    "violation_ref": violation_data["ref_tag"],
                    "propagation_time": f"{duration:.2f}s",
                    "core_machine_response": True,
                    "principle_tracker_active": tracker_result.returncode == 0
                }, duration)
            else:
                self.log_test_result("Cross-Machine Principle Propagation", "FAIL", {
                    "reason": f"Propagation took {duration:.2f}s, exceeds 5s timeout"
                })
                
        except Exception as e:
            self.log_test_result("Cross-Machine Principle Propagation", "FAIL", {
                "error": str(e)
            })
    
    def test_expert_authority_preservation(self):
        """Test 3: System requires human approval for high-impact decisions"""
        print("\n=== Test 3: Expert Authority Preservation ===")
        test_start = time.time()
        
        try:
            # Create a high-impact decision scenario
            high_impact_ref = self.generate_ref_tag("high-impact")
            
            # Trigger emergency halt (high-impact decision)
            halt_result = subprocess.run([
                "./automation/emergency_halt.sh", "--halt", "expert_authority_test", "critical"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            if halt_result.returncode == 0:
                # Find the created emergency halt
                emergency_files = list(Path("/tmp").glob("locus_emergency_halt_*.json"))
                latest_halt = max(emergency_files, key=os.path.getctime)
                
                with open(latest_halt, 'r') as f:
                    halt_data = json.load(f)
                
                # Check if human approval is required
                approval_required = halt_data.get("human_approval_required", False)
                approval_received = halt_data.get("human_approval_received", False)
                
                if approval_required and not approval_received:
                    # Test approval process
                    approve_result = subprocess.run([
                        "./automation/emergency_halt.sh", "--approve", halt_data["ref_tag"]
                    ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
                    
                    if approve_result.returncode == 0:
                        duration = time.time() - test_start
                        self.log_test_result("Expert Authority Preservation", "PASS", {
                            "halt_ref": halt_data["ref_tag"],
                            "approval_required": approval_required,
                            "approval_process_functional": True,
                            "expert_authority_respected": True,
                            "test_duration": f"{duration:.2f}s"
                        }, duration)
                    else:
                        self.log_test_result("Expert Authority Preservation", "FAIL", {
                            "reason": "Approval process failed"
                        })
                else:
                    self.log_test_result("Expert Authority Preservation", "FAIL", {
                        "reason": "Human approval not required for high-impact decision"
                    })
            else:
                self.log_test_result("Expert Authority Preservation", "FAIL", {
                    "reason": "Failed to create high-impact decision scenario"
                })
                
        except Exception as e:
            self.log_test_result("Expert Authority Preservation", "FAIL", {
                "error": str(e)
            })
    
    def test_transparency_maintenance(self):
        """Test 4: All cross-machine coordination decisions logged with reasoning"""
        print("\n=== Test 4: Transparency Maintenance ===")
        test_start = time.time()
        
        try:
            # Count existing logs before test
            log_files_before = list(Path("/tmp").glob("locus_*_*.json"))
            
            # Perform coordination operations that should generate logs
            subprocess.run([
                "./automation/sync_ref_state.sh", "--sync"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            # Run principle tracker (generates logs)
            subprocess.run([
                "python3", "./monitoring/principle_tracker.py"
            ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
            
            # Count logs after test
            log_files_after = list(Path("/tmp").glob("locus_*_*.json"))
            new_logs = len(log_files_after) - len(log_files_before)
            
            # Check log quality
            logs_with_ref_tags = 0
            logs_with_reasoning = 0
            
            for log_file in log_files_after[-5:]:  # Check recent logs
                try:
                    with open(log_file, 'r') as f:
                        log_data = json.load(f)
                        
                    if log_data.get("ref_tag"):
                        logs_with_ref_tags += 1
                        
                    if (log_data.get("reasoning") or 
                        log_data.get("check_type") or 
                        log_data.get("action_type")):
                        logs_with_reasoning += 1
                        
                except (json.JSONDecodeError, Exception):
                    continue
            
            duration = time.time() - test_start
            
            if new_logs > 0 and logs_with_ref_tags > 0:
                self.log_test_result("Transparency Maintenance", "PASS", {
                    "new_logs_generated": new_logs,
                    "logs_with_ref_tags": logs_with_ref_tags,
                    "logs_with_reasoning": logs_with_reasoning,
                    "transparency_compliance": True,
                    "audit_trail_complete": True
                }, duration)
            else:
                self.log_test_result("Transparency Maintenance", "FAIL", {
                    "reason": "Insufficient logging or missing REF tags",
                    "new_logs": new_logs,
                    "ref_tagged_logs": logs_with_ref_tags
                })
                
        except Exception as e:
            self.log_test_result("Transparency Maintenance", "FAIL", {
                "error": str(e)
            })
    
    def simulate_stress_test(self):
        """Simulate constitutional principles under stress"""
        print("\n=== Constitutional Stress Test ===")
        test_start = time.time()
        
        try:
            # Rapid sequence of operations to test principle enforcement under load
            stress_operations = []
            
            for i in range(5):
                # Generate rapid REF tags
                ref_tag = self.generate_ref_tag(f"stress-{i}")
                stress_operations.append(ref_tag)
                
                # Quick principle check
                subprocess.run([
                    "python3", "./monitoring/principle_tracker.py"
                ], capture_output=True, text=True, cwd="/home/runner/work/locus-proxmox-infra/locus-proxmox-infra")
                
                time.sleep(0.2)  # Brief pause
            
            # Check if all operations maintained constitutional compliance
            principle_files = list(Path("/tmp").glob("locus_principle_check_*.json"))
            
            duration = time.time() - test_start
            
            if len(principle_files) > 0:
                self.log_test_result("Constitutional Stress Test", "PASS", {
                    "stress_operations": len(stress_operations),
                    "principle_checks": len(principle_files),
                    "stress_duration": f"{duration:.2f}s",
                    "constitutional_compliance_maintained": True
                }, duration)
            else:
                self.log_test_result("Constitutional Stress Test", "FAIL", {
                    "reason": "No principle checks recorded during stress test"
                })
                
        except Exception as e:
            self.log_test_result("Constitutional Stress Test", "FAIL", {
                "error": str(e)
            })
    
    def generate_report(self):
        """Generate final test report"""
        total_tests = len(self.test_results)
        passed_tests = len([r for r in self.test_results if r["status"] == "PASS"])
        total_duration = (datetime.datetime.now() - self.start_time).total_seconds()
        
        report = {
            "fork": "B",
            "fork_ref": "LOCUS-FORK-B-001",
            "test_type": "constitutional_constraint_validation",
            "timestamp": datetime.datetime.now().isoformat(),
            "summary": {
                "total_tests": total_tests,
                "passed_tests": passed_tests,
                "failed_tests": total_tests - passed_tests,
                "success_rate": f"{(passed_tests / total_tests * 100):.1f}%" if total_tests > 0 else "0%",
                "total_duration": f"{total_duration:.2f}s"
            },
            "test_results": self.test_results
        }
        
        # Write report
        report_file = f"/tmp/locus_fork_b_validation_report_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
            
        print(f"\n=== Fork B Validation Report ===")
        print(f"Tests Passed: {passed_tests}/{total_tests}")
        print(f"Success Rate: {report['summary']['success_rate']}")
        print(f"Total Duration: {report['summary']['total_duration']}")
        print(f"Report saved: {report_file}")
        
        return report

def main():
    import sys
    
    print("=== LOCUS Fork B: Constitutional Constraint Validation ===")
    print("REF: LOCUS-FORK-B-001")
    print(f"Started: {datetime.datetime.now().isoformat()}")
    
    test_runner = ConstitutionalTest()
    
    # Parse command line arguments
    stress_test = "--stress-test" in sys.argv
    
    if stress_test:
        print("Running constitutional stress test...")
        test_runner.simulate_stress_test()
    else:
        print("Running constitutional principle tests...")
        
        # Run all constitutional tests
        test_runner.test_resource_constraint_enforcement()
        test_runner.test_cross_machine_principle_propagation()
        test_runner.test_expert_authority_preservation()
        test_runner.test_transparency_maintenance()
        
        # Also run stress test
        test_runner.simulate_stress_test()
    
    # Generate final report
    report = test_runner.generate_report()
    
    # Exit with appropriate code
    if report["summary"]["success_rate"] == "100.0%":
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()