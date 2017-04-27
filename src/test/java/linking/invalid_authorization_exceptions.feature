Feature: Handle all the Doc Linking API cases that result in HTTP 401 - UNAUTHORISED
  Reference Stories:
  XTN-4246: Implement exception handling for Authorization case

  Background:
    # Configuration
    * url documentRelationshipBaseUrl
    * def basicAuth = read ('classpath:sign-in.js')
    * configure headers = read('classpath:default-headers.json')

    # Global Vars
    * def project_id =  '1879048454'
    * def source_doc_id = '271341877549174248'
    * def target_doc_id = '271341877549174268'
    * def has_deviation_of = '819cad43-0838-47f3-b4a3-e977fb1d0dfe'

    Given path 'projects', project_id, 'documents', source_doc_id , 'relationships'

  Scenario Outline: Validate 401 when no Authorization header
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'NO_SUITABLE_AUTHENTICATION_METHOD'
    And match /Error/ErrorDescription == 'No suitable authentication method was found in the request, i.e. basic authentication headers were not present'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when invalid credentials provided in Basic Authorization header
    And header Authorization = 'Basic invalid_blah_blah'
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when unsupported Authorization type provided
    And header Authorization = 'OAuth invalid_blah_blah'
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'NO_SUITABLE_AUTHENTICATION_METHOD'
    And match /Error/ErrorDescription == 'No suitable authentication method was found in the request, i.e. basic authentication headers were not present'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when a User making the request is Locked
    Given def locked_user = call basicAuth { username: 'knga', password: 'ac0n3x72' }
    And header Authorization = locked_user
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when a User making the request is Disabled
    Given def disabled_user = call basicAuth { username: 'bbrown', password: 'ac0n3x72' }
    And header Authorization = disabled_user
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when a User making the request is Invalid
    Given def invalid_user = call basicAuth { username: 'dummy', password: 'blah' }
    And header Authorization = invalid_user
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when username is correct but password is incorrect
    Given def valid_user_invalid_password = call basicAuth { username: 'poleary', password: 'blahblah' }
    And header Authorization = valid_user_invalid_password
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when username is incorrect but password is correct
    Given def invalid_user_valid_password = call basicAuth { username: 'someone', password: 'ac0n3x72' }
    And header Authorization = invalid_user_valid_password
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'LOGIN_FAILED'
    And match /Error/ErrorDescription == 'The login credentials provided failed the validation process'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |