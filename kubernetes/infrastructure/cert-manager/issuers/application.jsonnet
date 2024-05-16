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
        "api-token": "AgCUVUz/ao2zVVuCW6LzVKUv6xW9MwWPuSn6ZwgXWEstWm2q3Tkt5Y4Er5FX7IUvoq2qD9GVp7h0zzI1mgbQJT0/ToBzgWLw8U5Peyd3pXxc1wOPKfVthCDIX5WpXB+w97xuBdCJfH+neTcy6UGlxAPIkGjaEILupzkrM9UXAKEMBtbNZYd7O7dKYQyLNC3zVMvpdUfnTzzg4De7aMeT+ra0Fi6NerFZ7O9v2nNrwGn592zv0LFuOme6fQg9d4LxIeas3Nq0WhKhuj+PYATWUK+jkPhIL42j/If9TilS3ZXMsGG+KBdrQd5i4l5lQ4F5voALl19p9D06uWy2uDtIjXKW4M2MAdEEfCPi2rxK/ZzuVxhyJVMqEwB1/N/vS+krMhPAtFMcZHzKQmVFyDy75xm6F+cndiQFPOWrjMF3RD9LzDXWPdz+yZ0Y/lznHFxwR7xiHQuJ/53mF9gfUSbwCMWXnSJg6YlguTxNuRUMLCi7FcwFStgT9akp9JdoCKqPoTBTi1X38eXblRsdy1OrDXwcvVjZvRurWgAOVkMFVPj1kCMDzARSU2ACImDEoU277LCqIXrk/FqJ6EeBLx3DuOVhS30Bes0OdooIHOHOewUpnon2zoHKVxwn9JbY8g9voCZKdZMcTpHid1LVTRsJXyjXVShfPEFHukEiIQWQh+S7Zn+4rzjui50K4wIyMI/nSpWgJW3lT3g3X3eTaICpzYrvNmdy6ljIj5Ff/duo2ammrxoHv1z0ZADzSw=="
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

