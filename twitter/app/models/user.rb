class User < ApplicationRecord
	mount_uploader :dp, DpUploader
end
