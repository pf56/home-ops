function(
  cloudflare_email
)
  local secretName = "cloudflare-api-token";
  local namespace = "cert-manager";
[
  {
    apiVersion: "cert-manager.io/v1",
    kind: "ClusterIssuer",
    metadata: {
      name: "letsencrypt",
      namespace: namespace
    },
    spec: {
      acme: {
        server: "https://acme-v02.api.letsencrypt.org/directory",
        email: cloudflare_email,
        privateKeySecretRef: {
          name: "letsencrypt-key"
        },
        solvers: [
          {
            dns01: {
              cloudflare: {
                email: cloudflare_email,
                apiTokenSecretRef: {
                  name: secretName,
                  key: "api-token"
                }
              }
            }
          }
        ]
      }
    }
  },
  {
    apiVersion: "bitnami.com/v1alpha1",
    kind: "SealedSecret",
    metadata: {
      name: secretName,
      namespace: namespace
    },
    spec: {
      encryptedData: {
        "api-token": "AgAJlo6YA0Xhv7uGrA1drvB6z1+JhCKiZA1vJr/rjT2GcrX+2GtgxeHEliRVhC2pSQoqmZhADIPzwYs/P9OabG9nHZGNbea5dVtCTSokmXKuCGABryUP1ewTUVf9NlZQsv7MG7SB5HJ6nANqtpokibSHfSvQQkqvzeu9T7/3fxV3uGhytVHUAJHhQ/FPpQkXIf0yEGs7Yfm8zTVXNrGsIMcq4Tk0kTYgnRQDEVqMScbTpbI4+go/q2Ex6Zj7MRngzPmVvBKCHR643SeQPEDqQy7G722x9xZuopwsmZm5351bBsX5ubJhROVtq1SFWM8rLHIhj/I9Cw/LsG8EcktLpSCL/RYTmTdRtEOZUV1tEKxkCzrvM+Fgit/LOt7O7ywPaxdBLRDeOjVVPzkOfuBPs7kQGASqDtspOlcqc09grizOKGHhlJEu54q+5066E3Vl2+oFyN5PBoHVjyHaom94J76gcBWmtGtxno4ff5LR9gn10nMM93QETnpK/Gj5/thUL+JtcYHqveDzF6l9ROoeMwMy+4IaxNKPhx+Zc+wjdHE7zCa6DJlraFUdrXxNrV5mPtF4Flb5wxuC1X4u3oxW1C2stn0s0np/VFJrS8zgXNtytg3ElGuvTuhKz3aJAphKKB4y03Hb1C44xO+tnqZmFG8p/D1w/3E3q9vwjxEbmjfRIXDc/uGzWI5EGa3liEcUl1wukOyTaVQxJvgpuB9jnv0hLM2UIAoVnZo8uDFVy2BWYWr7Vft9DMkL"
      },
      template: {
        metadata: {
          name: secretName,
          namespace: namespace
        }
      }
    }
  }
]

