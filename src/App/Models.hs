{-# LANGUAGE UndecidableInstances #-}

module App.Models where

import Data.Functor.Identity (Identity)
import Data.Text (Text)
import GHC.Generics (Generic)

import Data.Time (LocalTime)

import Database.Beam (Beamable, Columnar, Database, PrimaryKey, Table (primaryKey), TableEntity)

-- User

data UserT f = User
    { name :: Columnar f Text
    , login :: Columnar f Text
    , password :: Columnar f Text
    , registrationDate :: Columnar f LocalTime
    , isAdmin :: Columnar f Bool
    , canPublishNews :: Columnar f Bool
    }
    deriving stock (Generic)
    deriving anyclass (Beamable)

type User = UserT Identity
type UserId = PrimaryKey UserT Identity

deriving stock instance Show User
deriving stock instance Eq User

instance Table UserT where
    primaryKey r = UserId r.name
    data PrimaryKey UserT f = UserId (Columnar f Text)
        deriving stock (Generic)
        deriving anyclass (Beamable)

-- Category

data CategoryT f = Category
    { name :: Columnar f Text
    , supercategory :: PrimaryKey CategoryT f
    }
    deriving stock (Generic)
    deriving anyclass (Beamable)

instance Table CategoryT where
    primaryKey r = CategoryId r.name
    data PrimaryKey CategoryT f = CategoryId (Columnar f Text)
        deriving stock (Generic)
        deriving anyclass (Beamable)

type Category = CategoryT Identity
type CategoryId = PrimaryKey CategoryT Identity

deriving stock instance (Show (PrimaryKey CategoryT Identity)) => Show Category
deriving stock instance (Eq (PrimaryKey CategoryT Identity)) => Eq Category

-- News

data NewsItemT f = News
    { title :: Columnar f Text
    , created :: Columnar f LocalTime
    , creator :: PrimaryKey UserT f
    , category :: PrimaryKey CategoryT f
    ,  content :: Columnar f Text
    , isPublicated :: Columnar f Bool
    }
    deriving stock (Generic)
    deriving anyclass (Beamable)

instance Table NewsItemT where
    primaryKey r = NewsItemId r.title
    data PrimaryKey NewsItemT f = NewsItemId (Columnar f Text)
        deriving stock (Generic)
        deriving anyclass (Beamable)

type NewsItem = NewsItemT Identity
type NewsItemId = PrimaryKey NewsItemT Identity

deriving stock instance
    ( Show (PrimaryKey UserT Identity)
    , Show (PrimaryKey CategoryT Identity)
    ) =>
    Show NewsItem
deriving stock instance
    ( Eq (PrimaryKey UserT Identity)
    , Eq (PrimaryKey CategoryT Identity)
    ) =>
    Eq NewsItem

-- DB

data AppDb f = AppDb
    { users :: f (TableEntity UserT)
    , categories :: f (TableEntity CategoryT)
    , news :: f (TableEntity NewsItemT)
    }
    deriving stock (Generic)
    deriving anyclass (Database be)
