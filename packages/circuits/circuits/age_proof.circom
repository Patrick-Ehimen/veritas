pragma circom 2.0.0;

/*
Age Proof Circuit
This circuit proves that a person's age is above a certain threshold
without revealing the exact age.
*/

template AgeProof() {
    // Private inputs
    signal private input birthYear;
    signal private input birthMonth;
    signal private input birthDay;
    signal private input salt; // For privacy
    
    // Public inputs
    signal input currentYear;
    signal input currentMonth;
    signal input currentDay;
    signal input minAge;
    signal input commitment; // Hash of private inputs
    
    // Output
    signal output isValid;
    
    // Components
    component hasher = Poseidon(4);
    component geq = GreaterEqualThan(8);
    
    // Verify commitment
    hasher.inputs[0] <== birthYear;
    hasher.inputs[1] <== birthMonth;
    hasher.inputs[2] <== birthDay;
    hasher.inputs[3] <== salt;
    commitment === hasher.out;
    
    // Calculate age in years (simplified)
    var ageInYears = currentYear - birthYear;
    
    // Adjust for month and day
    var hasHadBirthday = 0;
    if (currentMonth > birthMonth) {
        hasHadBirthday = 1;
    } else if (currentMonth == birthMonth && currentDay >= birthDay) {
        hasHadBirthday = 1;
    }
    
    var actualAge = ageInYears;
    if (hasHadBirthday == 0) {
        actualAge = ageInYears - 1;
    }
    
    // Check if age is greater than or equal to minimum age
    geq.in[0] <== actualAge;
    geq.in[1] <== minAge;
    
    isValid <== geq.out;
}

template GreaterEqualThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;
    
    component lt = LessThan(n+1);
    lt.in[0] <== in[1];
    lt.in[1] <== in[0] + 1;
    
    out <== lt.out;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;
    
    component n2b = Num2Bits(n);
    n2b.in <== in[0] + (1<<n) - in[1];
    
    out <== 1 - n2b.out[n];
}

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1 = 0;
    
    var e2 = 1;
    for (var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc1 += out[i] * e2;
        e2 = e2 + e2;
    }
    
    lc1 === in;
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

component main = AgeProof();
