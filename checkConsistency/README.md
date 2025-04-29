# Check consistency

This tool will take two firewalls and tell you if they have equivalent behavior using symbolic execution.

# To run

`python3 main.py firewall1.c firewall2.c --output-dir ./my_debug_files`

# Key files

- firewall1.c and firewall2.c are the inputs. firewall1.c also has a helper function to create a mock packet from the inputs. firewall2.c uses this function as well.
- test_harness.c - this file gets read as a string, then compiled later.

# Limitations

Beacuse Klee has trouble with pointers, we cannot pass a proper xdp packet to the firewalls directly. Instead we pass symbolic values for the data, then construct a mock packet inside the firewall itself, then symbolically execute the firewall on the constrcuted packet.