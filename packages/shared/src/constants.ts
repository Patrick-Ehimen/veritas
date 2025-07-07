import type { NetworkConfig } from "./types";
import dotenv from "dotenv";

// Environment variables
dotenv.config();

// Network configurations
export const NETWORKS: Record<string, NetworkConfig> = {
  etherlink: {
    name: "Etherlink Testnet",
    rpcUrl: "https://node.ghostnet.etherlink.com",
    chainId: 128123,
    blockExplorer: "https://testnet.explorer.etherlink.com",
    contracts: {
      sbt: "0x1234567890123456789012345678901234567890",
      verifier: "0x1234567890123456789012345678901234567890",
      auth: "0x1234567890123456789012345678901234567890",
      reports: "0x1234567890123456789012345678901234567890",
    },
  },
  local: {
    name: "Local Development",
    rpcUrl: "http://localhost:8545",
    chainId: 31337,
    blockExplorer: "http://localhost:4000",
    contracts: {
      sbt: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
      verifier: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
      auth: "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
      reports: "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9",
    },
  },
};

// ZK Circuit constants
export const ZK_CONSTANTS = {
  AGE_THRESHOLD: 18 * 365 * 24 * 60 * 60, // 18 years in seconds
  PROOF_VALIDITY_DURATION: 24 * 60 * 60, // 24 hours in seconds
  MAX_PROOF_SIZE: 1024 * 10, // 10KB
} as const;

// API endpoints
export const API_ENDPOINTS = {
  USER: "/api/user",
  GOV: "/api/gov",
  ORG: "/api/org",
  AUTH: "/api/auth",
} as const;

// Error messages
export const ERROR_MESSAGES = {
  INVALID_ADDRESS: "Invalid Ethereum address",
  NONCE_NOT_FOUND: "Nonce not found for this address",
  SIGNATURE_VERIFICATION_FAILED: "Signature verification failed",
  USER_NOT_FOUND: "User not found",
  PROOF_GENERATION_FAILED: "Proof generation failed",
  PROOF_VERIFICATION_FAILED: "Proof verification failed",
  UNAUTHORIZED: "Unauthorized access",
  INVALID_INPUT: "Invalid input data",
  INTERNAL_ERROR: "Internal server error",
} as const;

// Success messages
export const SUCCESS_MESSAGES = {
  USER_REGISTERED: "User registered successfully",
  IDENTITY_VERIFIED: "Identity verified successfully",
  PROOF_GENERATED: "Proof generated successfully",
  REPORT_SUBMITTED: "Report submitted successfully",
  DATA_RETRIEVED: "Data retrieved successfully",
} as const;

export const ENV_VARS = {
  NODE_ENV: process.env.NODE_ENV || "development",
  PORT: process.env.PORT || "5000",
  JWT_SECRET: process.env.JWT_SECRET || "your-secret-key",
  PRIVATE_KEY: process.env.PRIVATE_KEY || "",
  RPC_URL: process.env.RPC_URL || NETWORKS.etherlink.rpcUrl,
} as const;
