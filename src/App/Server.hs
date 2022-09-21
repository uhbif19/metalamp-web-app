module App.Server where

-- import qualified Network.Wai.Handler.Warp as Warp
import Data.Text (Text)
import Servant.API (Get, Delete, Post, ReqBody, JSON, Capture, (:>), (:<|>))

import App.Models (NewsItem)

type API = "news" :> (
    -- ReqBody '[JSON] NewsItem :> Post '[JSON] Text
    Capture "id" Int :> Get '[JSON] Text
    -- :<|> Capture "id" Int :> Delete '[JSON] Text
    )

