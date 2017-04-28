@run
Feature: Handle invalid Project ID cases in the Doc Linking API
  Reference Stories:
  XTN-4336: Validate Document IDs exist and are accessible 404 for Source and 400 for target document

  Background:
    # Configuration
    * url documentRelationshipBaseUrl
    * configure headers = read('classpath:default-headers.json')
    * def basicAuth = read('classpath:sign-in.js')
    * def poleary = call basicAuth { username: 'poleary', password: 'ac0n3x72' }
#    * header Authorization = poleary - Karate Bug - The Authorization header has duplicate token (NOT being overwritten)


    # Global Vars
    * def project_id =  '1879048454'
    * def source_doc_id = '271341877549174248'
    * def target_doc_id = '271341877549174268'
    * def has_deviation_of = '819cad43-0838-47f3-b4a3-e977fb1d0dfe'

  Scenario Outline: Expect HTTP 404 when Project ID is invalid
    Given path 'projects', '1879048004', 'documents', source_doc_id , 'relationships'
    And header Authorization = poleary
    And request
    """
    <Relationships>
      <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174268" />
    </Relationships>

    """
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'PROJECT_NOT_FOUND'
    And match /Error/ErrorDescription == 'The project specified in the path of the request was not found'

    Examples:
      | method | status |
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |

  Scenario Outline: Expect HTTP 404 when Project ID is malformed
    Given path 'projects', '1879048004_malformed', 'documents', source_doc_id , 'relationships'
    And header Authorization = poleary
    And request
    """
    <Relationships>
      <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174268" />
    </Relationships>

    """
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'PROJECT_NOT_FOUND'
    And match /Error/ErrorDescription == 'The project specified in the path of the request was not found'

    Examples:
      | method | status |
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |

  @killstring
  Scenario Outline: Expect HTTP 404 when Project ID has a kill string in it
    Given path 'projects', '1879048004_a<u>?&reg;#ñ語中$=">>%AE</u>', 'documents', source_doc_id , 'relationships'
    And header Authorization = poleary
    And request
    """
    <Relationships>
      <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174268" />
    </Relationships>

    """
    When method <method>
    Then status <status>
    And match response == 'Not Found'

    Examples:
      | method | status |
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |

  Scenario Outline: Expect HTTP 404 when Project ID is not accessible to user
    Given path 'projects', project_id, 'documents', source_doc_id , 'relationships'
    And def user_not_on_project = call basicAuth { username: 'jdoe', password: 'ac0n3x72'}
    And header Authorization = user_not_on_project
    And request
    """
    <Relationships>
      <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174268" />
    </Relationships>

    """
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'PROJECT_NOT_FOUND'
    And match /Error/ErrorDescription == 'The project specified in the path of the request was not found'

    Examples:
      | method | status |
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |

  # XTN-4424
  Scenario Outline: Expect HTTP 404 when Project ID is big integer
    Given path 'projects', '271341877549174268567567858768789', 'documents', source_doc_id , 'relationships'
    And header Authorization = poleary
    And request
    """
   <Relationships>
     <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99" RelatedDocumentId="271341877549174191" />
     <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99" RelatedDocumentId="271341877549174222" />
   </Relationships>

    """
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'PROJECT_NOT_FOUND'
    And match /Error/ErrorDescription == 'The project specified in the path of the request was not found'

    Examples:
      | method | status |
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |