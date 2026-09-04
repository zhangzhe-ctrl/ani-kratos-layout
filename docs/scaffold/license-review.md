# Runtime Dependency License Review

- Scope: Linux/amd64 runtime module SBOM only
- Source: [bom.cdx.json](bom.cdx.json)
- Evidence date: 2026-09-04
- Inventory result: **pass**
- Legal/distribution approval: **not_verified**

CycloneDX GoMod `v1.12.0` examined the 34 non-main runtime components with
license detection enabled. Detection is retained under CycloneDX evidence; it
is not promoted to an asserted license and is not legal advice.

| Detected SPDX license | Components |
| --- | ---: |
| Apache-2.0 | 18 |
| BSD-3-Clause | 9 |
| MIT | 6 |
| BSD-2-Clause | 1 |
| no detected evidence | 0 |

No copyleft license was detected in this runtime inventory. That observation is
bounded to the exact modules and tool recorded in the SBOM; it is not a policy
that rejects or approves future dependencies.

`scripts/verify-supply-chain` and `make audit` fail when the notice hash changes,
any runtime component loses detected license evidence, or this table's counts
drift from the committed BOM. CI runs that gate; legal interpretation and
distribution approval remain human decisions.

## Recorded obligations

- MIT and BSD distributions retain the applicable copyright and license text.
- Apache-2.0 distributions retain the license, preserve required attribution
  and modification notices, and carry an upstream NOTICE when one applies.
- Binary/container packaging must collect the applicable dependency notices;
  LAYOUT-0 does not build or publish such an artifact, so that packaging check
  remains `not_verified`.
- Test-only dependencies are not in this runtime SBOM and require a separate
  development/distribution review if they are ever shipped.

## Upstream layout notice and ANI code

`THIRD_PARTY_NOTICES.go-kratos-layout.txt` is byte-identical to the MIT notice
in the official generated baseline. It is retained in the layout and generated
services to preserve the upstream notice.

The notice is deliberately not named `LICENSE`. LAYOUT-0 does not decide the
license for ANI-authored changes or for a generated service repository. The
repository owner must make that decision before any remote publication. This
avoids silently licensing a new service merely because its scaffold originated
from an MIT-licensed template.

## Interpretation

`pass` here means the local runtime dependency inventory is complete enough
for LAYOUT-0 review and its known notice obligations are recorded. It does not
mean counsel approved a product distribution, that a container contains all
required texts, or that ANI-authored code has a selected license.
