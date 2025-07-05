import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

async function deploySoulBoundTokenFixture() {
  const [owner, otherAccount] = await hre.ethers.getSigners();
  const SoulBoundToken = await hre.ethers.getContractFactory("SoulBoundToken");
  const sbt = await SoulBoundToken.deploy(owner.address);
  console.log("Deployed SoulBoundToken contract at:", sbt.target);
  return { sbt, owner, otherAccount };
}

describe("SoulBoundToken", function () {
  describe("Identity Issuance", function () {
    it("Should allow the contract owner to issue a new identity", async function () {
      const { sbt, owner } = await loadFixture(deploySoulBoundTokenFixture);

      console.log("Issuing identity to:", owner.address);

      await sbt.issueIdentity(owner.address, "uid123", "01/01/1990", "Alice");

      const identity = await sbt.getIdentity(owner.address);
      console.log("Fetched identity:", identity);

      expect(identity.identifier).to.equal("uid123");
      expect(identity.birthdate).to.equal("01/01/1990");
      expect(identity.fullname).to.equal("Alice");
    });

    it("Should prevent non-owner from issuing identities", async function () {
      const { sbt, otherAccount } = await loadFixture(
        deploySoulBoundTokenFixture
      );

      console.log(
        "Attempting to issue identity from non-owner:",
        otherAccount.address
      );

      await expect(
        sbt
          .connect(otherAccount)
          .issueIdentity(otherAccount.address, "uid123", "01/01/1990", "Alice")
      ).to.be.revertedWithCustomError(sbt, "OwnableUnauthorizedAccount");
    });
  });

  describe("Soulbound Behavior", function () {
    it("Should prevent token transfers between addresses", async function () {
      const { sbt, owner, otherAccount } = await loadFixture(
        deploySoulBoundTokenFixture
      );

      // First issue an identity
      console.log("Issuing identity to:", owner.address);
      await sbt.issueIdentity(owner.address, "uid123", "01/01/1990", "Alice");
      const tokenId = await sbt.walletToToken(owner.address);

      console.log("Token ID for owner:", tokenId);

      // Try to transfer the token and expect it to revert
      console.log(
        "Attempting to transfer token from",
        owner.address,
        "to",
        otherAccount.address
      );
      await expect(
        sbt
          .connect(owner)
          .transferFrom(owner.address, otherAccount.address, tokenId)
      ).to.be.revertedWith("SBT: non-transferable token");
    });
  });
});
