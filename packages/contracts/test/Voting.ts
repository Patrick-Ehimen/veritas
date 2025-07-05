import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

async function deployVotingFixture() {
  const [admin, voter1, voter2] = await hre.ethers.getSigners();
  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();
  return { voting, admin, voter1, voter2 };
}

describe("Voting", function () {
  describe("Poll Management", function () {
    it("Should allow admin to open a poll", async function () {
      const { voting, admin } = await loadFixture(deployVotingFixture);

      await expect(voting.openPoll()).to.emit(voting, "PollOpened");

      expect(await voting.pollOpen()).to.be.true;
    });
  });

  describe("Voting Logic", function () {
    it("Should allow permitted voters to vote", async function () {
      const { voting, admin, voter1 } = await loadFixture(deployVotingFixture);

      // Grant permission and open poll
      await voting.grantPermission(voter1.address);
      await voting.openPoll();

      // Submit vote
      await expect(voting.connect(voter1).submitVote(true))
        .to.emit(voting, "VoteCast")
        .withArgs(voter1.address, true);

      const [approvals, rejections] = await voting.fetchResults();
      expect(approvals).to.equal(1);
      expect(rejections).to.equal(0);
    });
  });
});
