cardano-cli address key-gen \
 --verification-key-file orcfax-payment.vkey \
 --signing-key-file orcfax-payment.skey

 cardano-cli address build \
 --payment-verification-key-file orcfax-payment.vkey \
 --out-file orcfax-payment.addr \
 --mainnet

 cardano-cli address key-hash \
  --payment-verification-key-file orcfax-payment.vkey \
  --out-file orcfax-payment.hash

  mv orcfax-payment.* ../../keys