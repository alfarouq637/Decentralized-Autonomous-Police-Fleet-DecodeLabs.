//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract AutonomousPoliceFleet {

    address public hqAdmin;

    constructor () {
        hqAdmin = msg.sender;
    }

    struct Robot {
        bool isRegistered;
        uint128 capabilities;
        uint256 assignedZone;
        uint8 batteryLevel;
        bool isSolarCharging;
        uint256 lastMaintenanceTime;
        uint256 activeTaskId;
        bool inHotPursuit;
    }

    enum ThreatLevel {Normal , Suspicious , DistractionTactic , ArmedAndDangerous}

    struct SuspectReport {
        bytes32 BodyMetricsHash;
        ThreatLevel level;
        uint256 locationZone;
        uint256 TimesTamp;
    }

    mapping (uint256 => SuspectReport) public activeThreats;
    uint256 public ThreatCounter;

    mapping(address => Robot) public robots;
    uint256 public taskCounter;

    event ActionApproved (address indexed robot , uint256 taskID , bytes32 targetHash);

    event HumanPoliceDispatch (uint256 zone , ThreatLevel , bytes32 suspectHash);

    event FleetAlert (uint256 zone , ThreatLevel level);

    modifier onlyAdmin() {
        require(msg.sender == hqAdmin, "Access Denied: HQ Admin only");
        _;
    }

    function registerRobot(address _robot, uint128 _capabilities, uint256 _zone) external onlyAdmin {
        robots[_robot] = Robot({
            isRegistered: true,
            capabilities: _capabilities,
            assignedZone: _zone,
            batteryLevel: 100,
            isSolarCharging: false,
            lastMaintenanceTime: block.timestamp,
            activeTaskId: 0,
            inHotPursuit: false 
        });
    }

    function updateTelemetry (uint8 _battery, bool _isSolar) external {
        require(robots[msg.sender].isRegistered, "Error: Unvetted Robot");
        require(_battery <= 100, "Invalid battery percentage");

        robots[msg.sender].batteryLevel = _battery;
        robots[msg.sender].isSolarCharging = _isSolar;
    }

    function performWeeklyMaintenance(address _robot) external onlyAdmin {
        require(robots[_robot].isRegistered, "Error: Unvetted Robot");
        robots[_robot].lastMaintenanceTime = block.timestamp;
    }

    function reportAnomly (bytes32 _bodyMetricsHash , ThreatLevel _level) external {
        Robot storage r = robots[msg.sender];
        require (r.isRegistered , "Error: Unvetted Robot");

        ThreatCounter++;
        activeThreats[ThreatCounter] = SuspectReport({
            BodyMetricsHash: _bodyMetricsHash ,
            level: _level ,
            locationZone: r.assignedZone , 
            TimesTamp: block.timestamp
        });

        if (_level == ThreatLevel.DistractionTactic || _level == ThreatLevel.ArmedAndDangerous) { 
            emit HumanPoliceDispatch(r.assignedZone ,  _level , _bodyMetricsHash);
        }else {
            emit FleetAlert(r.assignedZone , _level);
        }
    }

    function requestAutonomousAction (uint256 _targetZone , bytes32 _suspectHash) external returns (uint256) {
        Robot storage r = robots[msg.sender];
        require (r.isRegistered , "Security: Unvetted Robot");
        require (r.activeTaskId == 0 , "Concurrency: Robot Busy");

        require (r.assignedZone == _targetZone || r.inHotPursuit , "Zone Violation: Outside assigned sector");
        require (block.timestamp <= r.lastMaintenanceTime + 7 days , "Safety Lock: Maintenance overdue");
        require(r.batteryLevel >= 20 || (r.batteryLevel >= 10 && r.isSolarCharging) , "Power Lock: Insufficient battery");

        taskCounter++;
        r.activeTaskId = taskCounter;

        emit ActionApproved(msg.sender , taskCounter , _suspectHash);

        return taskCounter;
    }

    function confirmArrest(uint256 _taskId , bytes32 _zkProof) external {
        Robot storage r = robots [msg.sender];

        require(r.activeTaskId == _taskId , "Security Alert: Unauthorized execution claim");

        require(_zkProof != 0x0 , "Invalid Execution Proof");

        r.activeTaskId = 0;

        r.inHotPursuit = false;
    }


}