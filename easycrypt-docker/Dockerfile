#
# Desc:   EasyCrypt test box for BU CS 512
# Author: Daniel Valentine
# Date:   2018-04-05
#

FROM ocaml/opam

# 1: refresh local repository cache (needs to be sudo'd for some reason)
RUN sudo apt update

# 2: install dependencies for EasyCrypt
RUN sudo apt install -y git          \
                        autoconf     \
                        python       \
                        libgmp-dev   \
                        libpcre3-dev \
                        zlib1g-dev

# 3: set up EasyCrypt OPAM repo
RUN opam repository add easycrypt git://github.com/EasyCrypt/opam.git && opam update

# 4: add EasyCrypt metapackages
RUN opam install -y ec-provers

# 5: install EasyCrypt
RUN opam install -y easycrypt

# 6: configure why3
RUN eval $(opam config env) && why3 config --detect
