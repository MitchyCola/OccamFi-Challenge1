{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeApplications #-}

module RandoAddr
    (
      mkShelleyAddr
    , mkByronAddr
    ) where

import Cardano.Address                  ( bech32, base58 )
import Cardano.Mnemonic                 ( SomeMnemonic (..), genEntropy, entropyToMnemonic )
import Cardano.Address.Derivation       ( Depth (..), XPrv, toXPub, indexFromWord32 )

import Cardano.Address.Style.Byron as Byron
import Cardano.Address.Style.Shelley as Shelley

mkShelleyAddr = do 

    -- Entropy
    ent <- genEntropy @256

    -- Menomic Phrase
    let mnem = SomeMnemonic $ entropyToMnemonic ent

    -- PassPhrase
    let sndFactor = mempty

    -- Root Key
    let rootK = Shelley.genMasterKeyFromMnemonic mnem sndFactor :: Shelley 'RootK XPrv

    -- Account Index
    let Just accIx = indexFromWord32 0x80000000

    -- Account Private Key
    let acctK = Shelley.deriveAccountPrivateKey rootK accIx

    -- Address Index
    let Just addrIx = indexFromWord32 0x00000000

    -- Address Private Key
    let addrK = Shelley.deriveAddressPrivateKey acctK Shelley.UTxOExternal addrIx

    -- Stake Address Key
    let stakeK = Shelley.deriveDelegationPrivateKey acctK

    -- Payment Address
    let (Right tag) = Shelley.mkNetworkDiscriminant 1
    let paymentCredential = Shelley.PaymentFromKey $ (toXPub <$> addrK)
    let payAddr = bech32 $ Shelley.paymentAddress tag paymentCredential

    -- Staking Address
    let delegationCredential = Shelley.DelegationFromKey $ (toXPub <$> stakeK)
    let stakeAddr = bech32 $ Shelley.delegationAddress tag paymentCredential delegationCredential

    return (payAddr, stakeAddr)


mkByronAddr = do
     -- Entropy
    ent <- genEntropy @256

    -- Menomic Phrase
    let mnem = SomeMnemonic $ entropyToMnemonic ent

    -- Root Key
    let rootK = Byron.genMasterKeyFromMnemonic mnem :: Byron 'RootK XPrv

    -- Account Index
    let Just accIx = indexFromWord32 0x80000000

    -- Account Private Key
    let acctK = Byron.deriveAccountPrivateKey rootK accIx

    -- Address Index
    let Just addIx = indexFromWord32 0x80000014

    -- Address Private Key
    let addrK = Byron.deriveAddressPrivateKey acctK addIx

    -- Payment Address
    let byronPayAddr = base58 $ Byron.paymentAddress byronMainnet (toXPub <$> addrK)

    return byronPayAddr