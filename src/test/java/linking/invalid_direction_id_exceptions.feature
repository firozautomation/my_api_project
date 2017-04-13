Feature: Handle invalid Direction ID cases in the Doc Linking API
  Reference Stories:
  XTN-4335: Validate direction ID in CREATE/DELETE return 400

  Background:
  # Configuration
    * url 'https://qa106.aconex.com/api/document-relationships'
    * def basicAuth = read ('classpath:sign-in.js')
    * def poleary = call basicAuth { username: 'poleary', password: 'ac0n3x72' }
    * configure headers = read('classpath:default-headers.json')
    * header Authorization = poleary

  # Global Vars
    * def project_id =  '1879048454'
    * def source_doc_id = '271341877549174248'
    * def target_doc_id = '271341877549174197'
    * def direction_id = '819cad43-0838-47f3-b4a3-e977fb1d0dfe'

  Scenario Outline: Validate 400 when Adding one document relationship that invalid Direction Id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99INVALID" RelatedDocumentId="271341877549174197"/>
  </Relationships>
  """
    When method <method>
    Then status 400
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == "The following 'DirectionId' is an invalid identifier: 948aee85-8962-4d36-ae12-e0279fd10c99INVALID"

    Examples:
      | method |
      | POST   |
      | DELETE |

  Scenario Outline: Validate 400 when Adding multiple document relationship and one of them has an invalid Direction Id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174121" />
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe-invalid" RelatedDocumentId="271341877549174197" />
  <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99" RelatedDocumentId="271341877549174240"/>
 </Relationships>
  """
    When method <method>
    Then status 400
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == "The following 'DirectionId' is an invalid identifier: 819cad43-0838-47f3-b4a3-e977fb1d0dfe-invalid"

    Examples:
      | method |
      | POST   |
      | DELETE |

  Scenario Outline: Validate 400 when adding a document relationship with a BLANK Direction Id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="" RelatedDocumentId='271341877549174121' />
  </Relationships>
  """
    When method <method>
    Then status 400
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == "The following 'DirectionId' is an invalid identifier: "

    Examples:
      | method |
      | POST   |
      | DELETE |

  Scenario Outline: Validate 400 when Direction Id is invalid but source and target document IDs are same
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe-invalid" RelatedDocumentId="271341877549174248" />
 </Relationships>
  """
    When method <method>
    Then status 400
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == 'Source document is in relationships'

    Examples:
      | method |
      | POST   |
      | DELETE |

  Scenario Outline: Expect HTTP 400 when Direction ID has kill string in it
    Given path 'projects', project_id, 'documents', source_doc_id , 'relationships'
    And request
    """
    <Relationships>
     <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe_a?;#ñ語中$='%AE" RelatedDocumentId='271341877549174197'/>
    </Relationships>
    """
    When method <method>
    Then status <status>
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == "The following 'DirectionId' is an invalid identifier: 819cad43-0838-47f3-b4a3-e977fb1d0dfe_a?;#ñ語中$='%AE"

    Examples:
      | method | status |
      | POST   | 400    |
      | DELETE | 400    |

  Scenario: Validate 400 when deleting a document relationship that is different to the one that exists
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174197"/>
  </Relationships>
  """
    When method post
    Then status 201

    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
    <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfeINVALID" RelatedDocumentId="271341877549174197"/>
  </Relationships>
  """
    When method delete
    Then status 400
    And match /Error/ErrorCode == 'INVALID_REQUEST'
    And match /Error/ErrorDescription == "The following 'DirectionId' is an invalid identifier: 819cad43-0838-47f3-b4a3-e977fb1d0dfeINVALID"

    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    When method get
    Then status 200
    And match /Relationships/Relationship/RelatedDocument/@Id == '#(target_doc_id)'
    And match /Relationships/Relationship/Direction/@Id == '#(direction_id)'