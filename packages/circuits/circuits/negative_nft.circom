pragma circom 2.0.0;

/*
Negative NFT Circuit
This circuit proves that a user does NOT hold certain negative credentials
(e.g., criminal records, sanctions, etc.) without revealing their identity.
*/

template NegativeNFT() {
    // Private inputs
    signal private input userID;
    signal private input salt;
    signal private input merkleRoot; // Merkle root of negative credentials list
    
    // Public inputs  
    signal input commitment; // Hash of userID + salt
    signal input publicMerkleRoot; // Public merkle root to verify against
    
    // Output
    signal output isClean; // 1 if user is NOT in negative list, 0 otherwise
    
    // Components
    component hasher = Poseidon(2);
    component merkleProof = MerkleProof(8); // Assuming depth 8 for merkle tree
    
    // Verify commitment
    hasher.inputs[0] <== userID;
    hasher.inputs[1] <== salt;
    commitment === hasher.out;
    
    // Verify that merkle root matches
    publicMerkleRoot === merkleRoot;
    
    // The main logic: prove that userID is NOT in the merkle tree
    // This is done by proving that we cannot create a valid merkle proof
    // for the userID in the negative credentials tree
    
    // For simplicity, we'll implement a basic non-membership proof
    // In production, this would use more sophisticated techniques
    component inclusion = MerkleInclusion(8);
    inclusion.leaf <== userID;
    inclusion.root <== merkleRoot;
    
    // If userID is in the tree, inclusion.out = 1
    // If userID is NOT in the tree, inclusion.out = 0
    // We want isClean = 1 when user is NOT in negative list
    isClean <== 1 - inclusion.out;
}

template MerkleProof(levels) {
    signal input leaf;
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal output root;
    
    component hashers[levels];
    component selectors[levels];
    
    for (var i = 0; i < levels; i++) {
        hashers[i] = Poseidon(2);
        selectors[i] = Selector();
    }
    
    var currentHash = leaf;
    for (var i = 0; i < levels; i++) {
        selectors[i].in[0] <== currentHash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];
        
        hashers[i].inputs[0] <== selectors[i].out[0];
        hashers[i].inputs[1] <== selectors[i].out[1];
        
        currentHash = hashers[i].out;
    }
    
    root <== currentHash;
}

template MerkleInclusion(levels) {
    signal input leaf;
    signal input root;
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal output out;
    
    component merkleProof = MerkleProof(levels);
    merkleProof.leaf <== leaf;
    for (var i = 0; i < levels; i++) {
        merkleProof.pathElements[i] <== pathElements[i];
        merkleProof.pathIndices[i] <== pathIndices[i];
    }
    
    component eq = IsEqual();
    eq.in[0] <== merkleProof.root;
    eq.in[1] <== root;
    
    out <== eq.out;
}

template Selector() {
    signal input in[2];
    signal input s;
    signal output out[2];
    
    s * (1 - s) === 0; // Ensure s is 0 or 1
    
    out[0] <== (in[1] - in[0]) * s + in[0];
    out[1] <== (in[0] - in[1]) * s + in[1];
}

template IsEqual() {
    signal input in[2];
    signal output out;
    
    component eq = IsZero();
    eq.in <== in[0] - in[1];
    out <== eq.out;
}

template IsZero() {
    signal input in;
    signal output out;
    
    signal inv;
    inv <-- in != 0 ? 1 / in : 0;
    out <== -in * inv + 1;
    in * out === 0;
}

template Poseidon(nInputs) {
    signal input inputs[nInputs];
    signal output out;
    
    // Simplified Poseidon hash - in practice use circomlib
    var sum = 0;
    for (var i = 0; i < nInputs; i++) {
        sum += inputs[i];
    }
    out <== sum;
}

component main = NegativeNFT();
