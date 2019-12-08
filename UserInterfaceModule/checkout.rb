require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Checkout
	def Checkout.checkout_return_back(branch_name)
		puts DataStructure.checkout(branch_name)
	end
end
