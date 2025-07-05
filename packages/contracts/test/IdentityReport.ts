import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

async function deployIdentityReportFixture() {
  const [owner, otherAccount] = await hre.ethers.getSigners();
  console.log("Deploying IdentityReport contract...");
  const IdentityReport = await hre.ethers.getContractFactory("IdentityReport");
  const identityReport = await IdentityReport.deploy(owner.address);
  console.log("Contract deployed at:", identityReport.target);
  return { identityReport, owner, otherAccount };
}

describe("IdentityReport", function () {
  describe("Report Issuance", function () {
    it("Should allow owner to issue a negative report", async function () {
      const { identityReport, owner, otherAccount } = await loadFixture(
        deployIdentityReportFixture
      );

      console.log("Issuing negative NFT...");
      await identityReport.issueNegativeNFT(
        otherAccount.address,
        "Fraud",
        "Identity verification failed",
        "Financial Authority"
      );

      console.log("Fetching reports for:", otherAccount.address);
      const reports = await identityReport.getReports(otherAccount.address);
      console.log("Reports fetched:", reports);

      expect(reports.length).to.equal(1);
      expect(reports[0].topic).to.equal("Fraud");
      expect(reports[0].details).to.equal("Identity verification failed");
      expect(reports[0].organization).to.equal("Financial Authority");
    });
  });

  describe("Soulbound Behavior", function () {
    it("Should prevent transfer of negative NFTs", async function () {
      const { identityReport, owner, otherAccount } = await loadFixture(
        deployIdentityReportFixture
      );

      console.log("Issuing negative NFT for soulbound test...");
      await identityReport.issueNegativeNFT(
        otherAccount.address,
        "Fraud",
        "Identity verification failed",
        "Financial Authority"
      );

      // Get the token ID (should be 1 as it's the first token)
      const tokenId = 1;
      console.log("Attempting to transfer tokenId:", tokenId);

      // Try to transfer and expect it to revert
      await expect(
        identityReport
          .connect(otherAccount)
          .transferFrom(otherAccount.address, owner.address, tokenId)
      ).to.be.revertedWith("Soulbound: token cannot be transferred");
      console.log("Transfer correctly reverted for soulbound token.");
    });
  });
});
