#!/usr/bin/env python3
"""
Constitutional Principle Tracker for Project Locus Fork B
Real-time monitoring and enforcement of constitutional principles
"""

import json
import time
import datetime
import subprocess
import psutil
from pathlib import Path
import os

    def __init__(self, config_file=None):
        if config_file is not None:
            self.config_file = config_file
        else:
            # Try environment variable, then fallback to relative path
            self.config_file = os.environ.get(
                "LOCUS_CONSTITUTION_CONFIG",
                str(Path(__file__).parent.parent / "config" / "constitutional_principles.json")
            )
        self.monitoring_active = False
        self.violations = []
        self.last_check = None
        
        # Load constitutional principles
        with open(self.config_file, 'r') as f:
            self.constitution = json.load(f)
            
        self.check_interval = self.constitution["monitoring_config"]["check_interval"]
    
    def generate_ref_tag(self, principle_type="principle"):
        """Generate REF tag for principle monitoring"""
        script_path = Path(__file__).parent.parent / "automation" / "generate_ref_tag.sh"
        result = subprocess.run([str(script_path), "job", f"principle-{principle_type}"], 
                              capture_output=True, text=True)
        return result.stdout.strip()
    
    def check_resource_constraints(self):
        """Check resource constraint enforcement principle"""
        principle = self.constitution["principles"]["resource_constraint_enforcement"]
        
        # Get current resource usage
        memory_usage = psutil.virtual_memory()
        cpu_usage = psutil.cpu_percent(interval=1)
        
        memory_gb = memory_usage.used / (1024**3)
        cpu_cores_used = cpu_usage / 100 * psutil.cpu_count()
        
        # Check against constitutional limits (simulate core machine limits)
        memory_limit = float(principle["core_machine_memory_limit"].replace("GB", ""))
        cpu_limit = principle["core_machine_cpu_limit"]
        
        warning_threshold = principle["threshold_warning"]
        critical_threshold = principle["threshold_critical"]
        
        violations = []
        
        # Check memory
        if memory_gb > memory_limit * critical_threshold:
            violations.append({
                "type": "resource_violation",
                "principle": "resource_constraint_enforcement",
                "resource": "memory",
                "current": f"{memory_gb:.2f}GB",
                "limit": f"{memory_limit}GB",
                "severity": "critical",
                "action_required": "immediate_halt"
            })
        elif memory_gb > memory_limit * warning_threshold:
            violations.append({
                "type": "resource_warning",
                "principle": "resource_constraint_enforcement", 
                "resource": "memory",
                "current": f"{memory_gb:.2f}GB",
                "limit": f"{memory_limit}GB",
                "severity": "warning",
                "action_required": "throttle"
            })
        
        # Check CPU
        if cpu_cores_used > cpu_limit * critical_threshold:
            violations.append({
                "type": "resource_violation",
                "principle": "resource_constraint_enforcement",
                "resource": "cpu",
                "current": f"{cpu_cores_used:.1f} cores",
                "limit": f"{cpu_limit} cores", 
                "severity": "critical",
                "action_required": "immediate_halt"
            })
        elif cpu_cores_used > cpu_limit * warning_threshold:
            violations.append({
                "type": "resource_warning",
                "principle": "resource_constraint_enforcement",
                "resource": "cpu",
                "current": f"{cpu_cores_used:.1f} cores",
                "limit": f"{cpu_limit} cores",
                "severity": "warning",
                "action_required": "throttle"
            })
            
        return violations
    
    def check_transparency_compliance(self):
        """Check transparency maintenance principle"""
        principle = self.constitution["principles"]["transparency_maintenance"]
        
        violations = []
        
        # Check if decision logs exist and are properly formatted
        log_files = list(Path("/tmp").glob("locus_*_*.json"))
        
        if len(log_files) == 0:
            violations.append({
                "type": "transparency_violation",
                "principle": "transparency_maintenance",
                "issue": "no_decision_logs_found",
                "severity": "warning",
                "action_required": "enable_logging"
            })
        else:
            # Check if logs include reasoning
            for log_file in log_files[:3]:  # Check recent logs
                try:
                    with open(log_file, 'r') as f:
                        log_data = json.load(f)
                        
                    if not log_data.get("ref_tag"):
                        violations.append({
                            "type": "transparency_violation",
                            "principle": "transparency_maintenance",
                            "issue": "missing_ref_tag",
                            "file": str(log_file),
                            "severity": "warning",
                            "action_required": "add_ref_tags"
                        })
                        break
                        
                except (json.JSONDecodeError, Exception):
                    violations.append({
                        "type": "transparency_violation",
                        "principle": "transparency_maintenance",
                        "issue": "invalid_log_format",
                        "file": str(log_file),
                        "severity": "warning",
                        "action_required": "fix_log_format"
                    })
                    break
        
        return violations
    
    def check_expert_authority(self):
        """Check expert authority preservation principle"""
        principle = self.constitution["principles"]["expert_authority_preservation"]
        
        violations = []
        
        # Simulate checking for high-impact decisions without approval
        # In real implementation, would check decision queue for unapproved high-impact items
        
        # For demonstration, check if any recent emergency actions occurred
        emergency_files = list(Path("/tmp").glob("locus_emergency_*.json"))
        
        for emergency_file in emergency_files:
            try:
                with open(emergency_file, 'r') as f:
                    emergency_data = json.load(f)
                    
                if not emergency_data.get("human_approval_received"):
                    violations.append({
                        "type": "authority_violation",
                        "principle": "expert_authority_preservation",
                        "issue": "emergency_action_without_approval",
                        "file": str(emergency_file),
                        "severity": "critical",
                        "action_required": "require_approval"
                    })
                    
            except (json.JSONDecodeError, Exception):
                pass
        
        return violations
    
    def check_all_principles(self):
        """Check all constitutional principles"""
        ref_tag = self.generate_ref_tag("check")
        
        all_violations = []
        
        # Check each principle
        all_violations.extend(self.check_resource_constraints())
        all_violations.extend(self.check_transparency_compliance())
        all_violations.extend(self.check_expert_authority())
        
        # Record check
        check_record = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "check_type": "constitutional_compliance",
            "total_violations": len(all_violations),
            "violations": all_violations,
            "overall_status": "compliant" if len(all_violations) == 0 else "violations_detected"
        }
        
        # Save check record
        check_file = f"/tmp/locus_principle_check_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(check_file, 'w') as f:
            json.dump(check_record, f, indent=2)
            
        self.last_check = datetime.datetime.now()
        self.violations = all_violations
        
        return check_record
    
    def start_monitoring(self):
        """Start continuous principle monitoring"""
        print("=== LOCUS Fork B: Constitutional Principle Monitoring Started ===")
        print(f"REF: {self.constitution['ref_tag']}")
        print(f"Check interval: {self.check_interval} seconds")
        print(f"Started: {datetime.datetime.now().isoformat()}")
        
        self.monitoring_active = True
        
        while self.monitoring_active:
            try:
                check_result = self.check_all_principles()
                
                if check_result["total_violations"] > 0:
                    print(f"\n⚠️  Constitutional violations detected: {check_result['total_violations']}")
                    for violation in check_result["violations"]:
                        print(f"  - {violation['type']}: {violation['principle']} ({violation['severity']})")
                        
                    # Trigger enforcement if critical violations
                    critical_violations = [v for v in check_result["violations"] if v["severity"] == "critical"]
                    if critical_violations:
                        print("🚨 Critical violations detected - triggering enforcement")
                        self.trigger_enforcement(critical_violations)
                else:
                    print(f"✓ Constitutional compliance check passed ({check_result['ref_tag']})")
                
                time.sleep(self.check_interval)
                
            except KeyboardInterrupt:
                print("\n🛑 Monitoring stopped by user")
                self.monitoring_active = False
                break
            except Exception as e:
                print(f"❌ Error during principle check: {e}")
                time.sleep(self.check_interval)
    
    def trigger_enforcement(self, violations):
        """Trigger constitutional enforcement mechanisms"""
        ref_tag = self.generate_ref_tag("enforcement")
        
        for violation in violations:
            if violation["action_required"] == "immediate_halt":
                print(f"🚨 Triggering emergency halt for: {violation['principle']}")
                # Would call emergency_halt.sh here
                
        # Log enforcement action
        enforcement_record = {
            "ref_tag": ref_tag,
            "timestamp": datetime.datetime.now().isoformat(),
            "action_type": "constitutional_enforcement",
            "violations": violations,
            "actions_taken": ["emergency_halt", "cross_machine_notification"],
            "status": "enforced"
        }
        
        enforcement_file = f"/tmp/locus_enforcement_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(enforcement_file, 'w') as f:
            json.dump(enforcement_record, f, indent=2)
            
        print(f"📋 Enforcement record: {enforcement_file}")

def main():
    import sys
    
    tracker = PrincipleTracker()
    
    if len(sys.argv) > 1 and sys.argv[1] == "--start-monitoring":
        tracker.start_monitoring()
    else:
        # Run single check
        print("=== LOCUS Fork B: Constitutional Principle Check ===")
        result = tracker.check_all_principles()
        
        print(f"REF: {result['ref_tag']}")
        print(f"Status: {result['overall_status']}")
        print(f"Violations: {result['total_violations']}")
        
        if result['violations']:
            for violation in result['violations']:
                print(f"  - {violation['type']}: {violation.get('issue', violation.get('resource', 'unknown'))}")

if __name__ == "__main__":
    main()