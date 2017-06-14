module Blockchain.Fae.Internal.Types where

import Blockchain.Fae.Internal.Crypto
import Blockchain.Fae.Internal.Lens

import Control.Applicative
import Control.Exception

import Control.Monad
import Control.Monad.State

import Data.Dynamic
import Data.Functor

import Data.Map (Map)
import qualified Data.Map as Map

import Numeric.Natural

newtype Fae a = 
  Fae { getFae :: StateT FaeState IO a }
  deriving (Functor, Applicative, Monad)

data FaeState =
  FaeState
  {
    persistentState :: FaePersist,
    transientState :: FaeTransient,
    parameters :: FaeParameters
  }

data FaePersist =
  FaePersist 
  {
    entries :: Entries,
    facets :: Facets,
    lastHash :: Digest
  }

data FaeTransient =
  FaeTransient
  {
    entryUpdates :: Entries,
    lastHashUpdate :: Digest,
    escrows :: Escrows,    
    sender :: PublicKey,
    currentFacet :: FacetID,
    currentFee :: Fee,
    currentFeeLeft :: Fee
  }

data FaeParameters =
  FaeParameters

newtype Entries = 
  Entries
  {
    useEntries :: Map EntryID Entry
  }

newtype Facets =
  Facets
  {
    useFacets :: Map FacetID Facet
  }

newtype Escrows =
  Escrows
  {
    useEscrows :: Map EscrowID Escrow
  }

data Entry =
  Entry
  {
    contract :: Dynamic, -- :: accumT -> Fae valT
    combine :: Dynamic, -- :: argT -> accumT -> accumT
    accum :: Dynamic, -- :: accumT
    facet :: FacetID
  }
data EntryID = EntryID Digest deriving (Eq, Ord, Show)

data Facet =
  Facet
  {
    fee :: Fee,
    depends :: [FacetID]
  }
data FacetID = FacetID -- TBD
  deriving (Eq, Ord, Show)

newtype Escrow =
  Escrow
  {
    account :: Dynamic -- an EscrowAccount tokT privT pubT
  }
data EscrowID = EscrowID -- TBD
  deriving (Eq, Ord, Show)

data EscrowAccount tokT privT pubT =
  EscrowAccount
  {
    private :: privT,
    public :: pubT    
  }

newtype Fee = Fee Natural

-- TH 
makeLenses ''Entries
makeLenses ''FaeParameters
makeLenses ''FaeTransient
makeLenses ''FaePersist
makeLenses ''FaeState
makeLenses ''Facets
makeLenses ''Escrows
makeLenses ''Entry
makeLenses ''Facet
makeLenses ''Escrow
makeLenses ''EscrowAccount

-- Instances

instance Digestible EntryID where
instance Digestible Entry where

