Feature: Handle all the Doc Linking API cases that result in HTTP 401 - UNAUTHORISED
  Reference Stories:
  XTN-4246: Implement exception handling for Authorization case

Background:
  # Configuration
  * url 'https://qa106.aconex.com/api/document-relationships'
  * def basicAuth = read ('classpath:sign-in.js')
  * def poleary = call basicAuth { username: 'poleary', password: 'ac0n3x72' }
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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |

  Scenario Outline: Validate 401 when invalid Authorization header
    And header Authorization = 'Basic invalid_blah_blah'
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

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
    And match /Error/ErrorCode == 'UNAUTHORIZED'
    And match /Error/ErrorDescription == 'Failed authorization attempt'

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |


  Scenario Outline: Validate 404 when user is NOT on the project
    Given def user_on_different_project = call basicAuth { username: 'jdoe', password: 'ac0n3x72' }
    And header Authorization = user_on_different_project
    And request ''
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'NOT-FOUND'
    And match /Error/ErrorDescription == 'Resource not found'

    Examples:
      | method | status |
      # GET from a user NOT on project should return a 404 - Resource not found
      | GET    | 404    |
      # Not implemented yet
      #| POST   | 404    |
      #| DELETE | 404    |