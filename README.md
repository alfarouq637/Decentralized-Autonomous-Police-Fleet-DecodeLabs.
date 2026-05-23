# 🚔 Decentralized-Autonomous-Police-Fleet-DecodeLabs.
DecodeLabs Project 1: Building a decentralized blockchain architecture to secure cyber-physical systems and autonomous robot fleets.

![Solidity](https://img.shields.io/badge/Solidity-^0.8.0-363636?style=flat-square&logo=solidity)
![Smart Contracts](https://img.shields.io/badge/Smart_Contracts-Ethereum-3c3c3d?style=flat-square&logo=ethereum)
![Edge AI](https://img.shields.io/badge/Edge_AI-Integration_Ready-0078d7?style=flat-square)
![DecodeLabs](https://img.shields.io/badge/Project_1-DecodeLabs-2ea44f?style=flat-square)

## 📌 Project Overview
This project establishes a **Zero-Trust, Decentralized Governance Layer** for a fleet of autonomous police robots. Instead of relying on a fragile, centralized server that can be compromised or experience downtime, this system utilizes Blockchain technology (Solidity Smart Contracts) to act as an immutable, transparent, and highly secure meta-controller.

The smart contract serves as the "Administrative Backbone," securely assigning tasks, verifying execution proofs, and orchestrating swarm intelligence, while the physical robots utilize low-level Edge-AI (C++/YOLOv8) for real-time local processing (e.g., threat detection, pose estimation, and suspect tracking).

## 🧠 Core Architecture & The Paradigm Shift
The system strictly separates **Heavy Computational Logic** (Off-chain) from **State Management & Verification** (On-chain):
1. **Edge-AI (Off-Chain):** Robots process environmental data locally to detect weapons, analyze body metrics (gait analysis for masked suspects), and detect distraction tactics. 
2. **Blockchain (On-Chain):** The Smart Contract enforces stringent "Gatekeeper Rules," assigning targets, managing physical constraints (battery/location), and validating Zero-Knowledge Proofs (ZK-Proofs) of task completion.

## ⚙️ Key Features & The Gatekeeper Rules

### 1. Authenticated Registration & Capability Bitmask
Robots are registered using a highly optimized `uint128` bitmask to store hardware capabilities (e.g., Lidar, heavy payload, steel nets). This reduces gas costs while efficiently indexing the physical traits of the fleet.

### 2. Multi-Layered Validation Gates (Concurrency & Geofencing)
Before a robot is authorized to engage a suspect, it must pass a rigorous, sub-second on-chain checkpoint:
* **Invalid Robot Validation:** Only vetted hardware can receive tasks.
* **Concurrency Shield:** Enforces "Robot Busy" logic to actively reject double-booking and prevent operational race conditions.
* **Geofencing & Hot Pursuit:** Robots are locked to assigned zones to optimize fleet distribution. However, a dynamic `inHotPursuit` protocol allows breaking the geofence in critical scenarios.
* **Telemetry & Safety Locks:** Engagements are blocked if battery levels drop below 20% (unless actively solar charging >10%) or if the weekly maintenance timestamp is overdue.

### 3. Swarm Intelligence & Human-Police Dispatch
The system includes an advanced threat-level assessment enum (`Normal`, `Suspicious`, `DistractionTactic`, `ArmedAndDangerous`). 
* If a robot detects a highly dangerous anomaly or a decoy, the contract immediately emits a `HumanPoliceDispatch` event to call for human backup.
* For lower-level threats, it broadcasts a `FleetAlert` event to nearby robots to re-route and encircle the target.

### 4. Proof-Driven Task Completion
To prevent mismatched completion claims, the system requires the specific assigned robot to submit a cryptographic hash/ZK-Proof verifying the successful deployment of countermeasures (e.g., steel net). Only then is the robot's state freed for future tasks.

## 🛠️ Smart Contract Structure
* `registerRobot()`: Vets and adds new machines to the active fleet.
* `updateTelemetry()`: Autonomous battery and solar status reporting.
* `reportAnomaly()`: Logs suspects' structural hashes and dynamically routes alerts based on the threat level.
* `requestAutonomousAction()`: The core IPO (Input-Process-Output) engine evaluating the Three-Door Checkpoint.
* `confirmArrest()`: Verifies execution proofs and resets the robot's operational state.

## 🚀 Deployment & Testing (Local Environment)
This contract has been rigorously tested on the **Remix VM (Cancun)** environment. 
1. **Compile:** Using Solidity `^0.8.0`.
2. **Deploy:** Instantiate the contract (deployer becomes `hqAdmin`).
3. **Execution Tests:** Successfully passed all edge cases including:
   - Rejecting unvetted addresses.
   - Throwing `"Concurrency: Robot Busy"` when double-tasked.
   - Blocking completion requests from mismatched or unauthorized addresses.

---
*Developed as part of the Robotics and Automation Engineering Internship at **DecodeLabs**.*
*Bridging the gap between Cyber-Physical Systems and Decentralized Blockchain Governance.*
