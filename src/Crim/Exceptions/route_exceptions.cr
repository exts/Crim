module Crim::Exceptions
  # Exception for empty route strings
  class EmptyRouteException < Exception
  end

  # Exception for invalid route methods not matching eg.: GET, POST, DELETE, etc...
  class InvalidRouteMethodException < Exception
  end
end
