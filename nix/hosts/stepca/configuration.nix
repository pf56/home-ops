{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../base/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "stepca";

  lollypops.deployment.ssh.host = lib.mkForce "10.0.60.4";
  lollypops.deployment.local-evaluation = true;

  services.step-ca = {
    enable = true;

    openFirewall = true;
    address = "10.0.60.4";
    port = 443;

    intermediatePasswordFile = config.sops.secrets.intermediate_password.path;

    settings = {
      root = "/var/lib/step-ca/certs/root_ca.crt";
      federatedRoots = null;
      crt = "/var/lib/step-ca/certs/intermediate_ca.crt";
      key = "/var/lib/step-ca/secrets/intermediate_ca_key";
      insecureAddress = "";
      dnsNames = [
        "ca.internal.paulfriedrich.me"
        "stepca.internal.paulfriedrich.me"
        "10.0.60.4"
      ];
      logger = {
        format = "text";
      };
      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
        badgerFileLoadingMode = "";
      };
      authority = {
        provisioners = [
          {
            type = "JWK";
            name = "ca@mail.paulfriedrich.me";
            key = {
              use = "sig";
              kty = "EC";
              kid = "UwgAP51hWQLHoFqTc6efZPCVGBBZPinS7pRFVgmRzQk";
              crv = "P-256";
              alg = "ES256";
              x = "e-wMr4BHBIru6f2IyJbEy3QG0MSnzYFGNnjxjVtGFqU";
              y = "kgXiB3HPm8sw9GxOaGn1D_ngKSd2EbDBV00b8DBwJ84";
            };
            encryptedKey = "eyJhbGciOiJQQkVTMi1IUzI1NitBMTI4S1ciLCJjdHkiOiJqd2sranNvbiIsImVuYyI6IkEyNTZHQ00iLCJwMmMiOjEwMDAwMCwicDJzIjoiQ0FfcFBuWHdwMGNfcFhRX1pQMUFJdyJ9.u3TRPdnky9Uo94nFNitw6dWO1X4fpNhiHdjR6P3x_qWK8t5oSemAvQ.EGzl8KxQLhSLaOR7.fAH3BVVRm5GuIIMt1gt2jwAk63q5Cvx6quO5DSKm8ztn372mqdX7_sYVUiF4ScMpIlGRctpnlCIYcTOuVRfoJrgCmp6sWtsbimVF91zSh2pS_yflfwVzCMewUQMsTRUVmCc8M-HQ4sNfwlBs-Tirqx9l0mQCHBuwA4grE-S3bffPFMHf4CAs0mMdD_g7kB2aAor8b-wKsJniSFcEftukFyG8ETTQSZi7o8mWvgokZViBF4YQ_cVGtBC9S_sndqQ1qnLVQf9e3FtxZQcj5k7QPowTolPgDMMP63oT-b9TuRDTxfn0qdVBM_dH4bPuIJlCxk5Y0H9UxkOE7VwtzaU.9fKcpvCB-C7mZCcXo2qJUA";
          }
        ];
      };

      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };

  sops = {
    secrets = {
      intermediate_password = { };
    };
  };

  system.stateVersion = "23.05";
}
