# CLAUDE.md

## QR-Code Generation for Agent Context

Agents can share access to Locus artifacts by generating a QR code that embeds a shortened URL. This is useful for quickly passing context or prompts to users or other agents.

### Steps:
1. Upload your artifact and copy the shortened URL.
2. Run `./scripts/generate_qr.sh <shortened-url>` to create a QR code image.
3. Share the QR code for agent context transfer.

See [docs/qr-share.md](docs/qr-share.md) for more details.