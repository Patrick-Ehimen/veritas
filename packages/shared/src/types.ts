import { z } from "zod";

// User Identity Schema
export const UserIdentitySchema = z.object({
  name: z.string().min(1),
  dob: z.string(),
  adharId: z.string().min(12).max(12),
  walletAddress: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
});

export type UserIdentity = z.infer<typeof UserIdentitySchema>;

// Verification Status
export const VerificationStatusSchema = z.enum([
  "pending",
  "verified",
  "rejected",
  "expired",
]);

export type VerificationStatus = z.infer<typeof VerificationStatusSchema>;

// ZK Proof Schema
export const ZKProofSchema = z.object({
  proof: z.object({
    pi_a: z.array(z.string()),
    pi_b: z.array(z.array(z.string())),
    pi_c: z.array(z.string()),
  }),
  publicSignals: z.array(z.string()),
});

export type ZKProof = z.infer<typeof ZKProofSchema>;

// Soul-Bound Token Schema
export const SBTSchema = z.object({
  tokenId: z.string(),
  owner: z.string(),
  metadata: z.object({
    name: z.string(),
    description: z.string(),
    image: z.string().optional(),
    attributes: z
      .array(
        z.object({
          trait_type: z.string(),
          value: z.union([z.string(), z.number()]),
        })
      )
      .optional(),
  }),
  issuedAt: z.string(),
  expiresAt: z.string().optional(),
});

export type SBT = z.infer<typeof SBTSchema>;

// Report Schema
export const ReportSchema = z.object({
  subject: z.string(),
  description: z.string(),
  company: z.string(),
  reportedBy: z.string(),
  timestamp: z.string(),
});

export type Report = z.infer<typeof ReportSchema>;

// API Response Schema
export const ApiResponseSchema = z.object({
  success: z.boolean(),
  message: z.string(),
  data: z.any().optional(),
  error: z.string().optional(),
});

export type ApiResponse<T = any> = {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
};

// Blockchain Network Types
export type NetworkType = "mainnet" | "testnet" | "local";

export interface NetworkConfig {
  name: string;
  rpcUrl: string;
  chainId: number;
  blockExplorer: string;
  contracts: {
    sbt: string;
    verifier: string;
    auth: string;
    reports: string;
  };
}
export const NetworkConfigSchema = z.object({
  name: z.string(),
  rpcUrl: z.string().url(),
  chainId: z.number(),
  blockExplorer: z.string().url(),
  contracts: z.object({
    sbt: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
    verifier: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
    auth: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
    reports: z.string().regex(/^0x[a-fA-F0-9]{40}$/),
  }),
});
