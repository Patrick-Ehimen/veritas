import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

async function deployKeyManagerFixture() {
  const [owner, otherAccount] = await hre.ethers.getSigners();
  console.log("Deploying KeyManager contract...");
  const KeyManager = await hre.ethers.getContractFactory("KeyManager");
  const keyManager = await KeyManager.deploy();
  console.log("KeyManager deployed at:", keyManager.target);
  return { keyManager, owner, otherAccount };
}

describe("KeyManager", function () {
  describe("User Registration", function () {
    it("Should allow owner to register a new user", async function () {
      const { keyManager, owner, otherAccount } = await loadFixture(
        deployKeyManagerFixture
      );

      console.log(
        "Testing registration by owner:",
        owner.address,
        "for user:",
        otherAccount.address
      );

      await expect(keyManager.registerUser(otherAccount.address))
        .to.emit(keyManager, "KeyCreated")
        .withArgs(otherAccount.address, (value: any) => {
          const isValid =
            value !==
            "0x0000000000000000000000000000000000000000000000000000000000000000";
          console.log(
            "KeyCreated event emitted with key:",
            value,
            "Valid:",
            isValid
          );
          return isValid;
        });

      const key = await keyManager.fetchKey(otherAccount.address);

      console.log("Fetched key for user:", otherAccount.address, "Key:", key);
      expect(key).to.not.equal(
        "0x0000000000000000000000000000000000000000000000000000000000000000"
      );
    });

    it("Should prevent non-owner from registering users", async function () {
      const { keyManager, otherAccount } = await loadFixture(
        deployKeyManagerFixture
      );
      // Attempt registration by a non-owner account
      console.log("Testing registration by non-owner:", otherAccount.address);

      await expect(
        keyManager.connect(otherAccount).registerUser(otherAccount.address)
      ).to.be.revertedWithCustomError(keyManager, "OwnableUnauthorizedAccount");
      console.log("Non-owner registration reverted as expected");
    });
  });
});
