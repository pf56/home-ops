{
  den.aspects.scx = {
    nixos = {
      services.scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };
    };
  };
}
