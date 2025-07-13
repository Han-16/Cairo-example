use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};

fn create_commitment(age: felt252, nonce: felt252) -> felt252 {
    let mut hasher = PoseidonTrait::new();
    hasher.update(age);
    hasher.update(nonce);
    hasher.finalize()
}

fn age_check(age: felt252, nonce: felt252, min_age: u32, commitment: felt252) -> bool {
    let age_u32 = age.try_into().unwrap();

    let is_age_valid = age_u32 >= min_age;
    let expected_commitment = create_commitment(age, nonce);
    let is_commitment_valid = expected_commitment == commitment;

    is_age_valid && is_commitment_valid
}

#[cfg(test)]
mod tests {
    use super::{age_check, create_commitment};

    #[test]
    fn test_valid_age_and_commitment() {
        let age: felt252 = 26;
        let nonce: felt252 = 123;
        let min_age: u32 = 20;

        let commitment = create_commitment(age, nonce);
        let result = age_check(age, nonce, min_age, commitment);

        assert!(result, "Should pass: age is valid and commitment matches");
    }

    #[test]
    fn test_invalid_age_too_young() {
        let age: felt252 = 16;
        let nonce: felt252 = 123;
        let min_age: u32 = 20;

        let commitment = create_commitment(age, nonce);
        let result = age_check(age, nonce, min_age, commitment);

        assert!(!result, "Should fail: age is below min_age");
    }

    #[test]
    fn test_invalid_commitment() {
        let age: felt252 = 26;
        let nonce: felt252 = 123;
        let min_age: u32 = 20;

        let wrong_commitment = 123456789.into();
        let result = age_check(age, nonce, min_age, wrong_commitment);

        assert!(!result, "Should fail: commitment does not match");
    }
}