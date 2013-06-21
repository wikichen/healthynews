# taken from: http://oinopa.com/2011/02/05/want-a-faster-test-suite.html

# spec/support/devise.rb
module Devise
  module Encryptors
    class Plain < Base
      class << self
        def digest(password, *args)
          password
        end

        def salt(*args)
          ""
        end
      end
    end
  end
end

Devise.encryptor = :plain