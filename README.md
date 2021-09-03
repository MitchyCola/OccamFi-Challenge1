This is my formal submissions to the Occam.Fi Challenge #1 from the AdaMaker.Space Hackathon.

This challenge entailed creating a Haskell module that can manipulate Cardano addresses (create random Byron, Shelley, stake addresses, ...), which was only possible in the command line.

---

My submission includes a module that has the ability to create random Public Addresses and Staking Addresses (if applicable). The module contains two functions: one for Shelley-era addresses, and another for Byron-era addresses.

All of the dependencies that are required for the module are listed in the `stack.yaml` files. I originally tried to use Cabal as my package manager, but I got stuck in "cabal-hell", where I could not get all of the dependencies resolved. Therefore, I switched over to Stack and it made my life immensely easier.

The module is dependent on 2 packages that are maintained by IOHK:

* [cardano-addresses](https://github.com/input-output-hk/cardano-addresses)
* [cardano-crypto](https://github.com/input-output-hk/cardano-crypto)

In order to test the module either clone this repo or download the .zip file, and then cd into this folder in a new terminal window. Enter `stack build` into the command line, this will install all of the required dependencies into an instance in Stack. This step only needs to accomplished the very first time. Once it builds, there will be some Deprecation Errors. All that these are saying is that Byron Addresses have been deprecated, and addresses that are Icarus and newer should be used. 

Then enter `stack exec ghci` to launch the environment. 

Then enter `import RandoAddr` into the Prelude. 

From here, there are 2 functions available: `mkShelleyAddr` and `mkByronAddr`. Neither function requires an input. Each function will generate their own 

Executing the `mkShelleyAddr` will output a tuple. The first element in the tuple is the Shelley Payment Address, and the second item is the associated Staking Address.

Executing the `mkByronAddr` function will directly output the Byron Payment Address.


### WARNING
THIS MODULE DOES NOT CURRENTLY SAVE OR EXPORT THE MNEMONIC PHRASE, THE ROOT KEY, OR ANY OF THE PRIVATE KEYS. DO NOT USE ANY OF THE ADDRESSES THAT ARE OUTPUTTED FOR ACTUALLY STORING FUNDS.