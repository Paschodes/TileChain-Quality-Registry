# TileChain Quality Registry

A Stacks blockchain smart contract for tracking ceramic tile quality certifications and authenticity verification.

## Overview

TileChain Quality Registry enables manufacturers, inspectors, and consumers to track and verify the quality and authenticity of ceramic tiles through an immutable blockchain registry.

## Features

- **Quality Certification**: Register tiles with quality ratings (1-10 scale)
- **Authenticity Verification**: Verify tile authenticity using unique tile IDs
- **Manufacturer Management**: Approve and track certified manufacturers
- **Inspection Tracking**: Record inspector information for each certification

## Contract Functions

### Public Functions

- `register-tile`: Register a new ceramic tile with quality certification
- `approve-manufacturer`: Approve a manufacturer for the quality registry

### Read-Only Functions

- `get-tile-info`: Retrieve complete tile information by ID
- `verify-tile-authenticity`: Check if a tile is authentic
- `is-manufacturer-approved`: Check manufacturer approval status
- `get-next-tile-id`: Get the next available tile ID

## Usage

```bash
# Deploy contract
clarinet deploy

# Register a tile
clarinet console
(contract-call? .tile-quality-registry register-tile 'ST1MANUFACTURER "BATCH001" u8 'ST1INSPECTOR)

# Verify tile authenticity
(contract-call? .tile-quality-registry verify-tile-authenticity u1)
```
