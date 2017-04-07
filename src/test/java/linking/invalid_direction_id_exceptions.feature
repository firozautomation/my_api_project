Feature: Handle all the Doc Linking API cases that result in HTTP 400 - UNAUTHORISED

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

  #Given path 'projects', project_id, 'documents', source_doc_id , 'relationships'

  #######################################################################################
  Scenario: Validate 400 when Adding one document relationship that invalid direction _id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99INVALID" RelatedDocumentId="271341877549174197"/>
  </Relationships>
  """
    When method post
    Then status 400
    #And match /Error/ErrorCode == 'ERROR_CODE'
    #And match /Error/ErrorDescription == 'Description for specific error'

  ##############################################################################################################
  Scenario: Validate 400 when Adding multiple document relationship and one of them has an invalid direction _id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174121" />
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe-invalid" RelatedDocumentId="271341877549174197" />
  <Relationship DirectionId="948aee85-8962-4d36-ae12-e0279fd10c99" RelatedDocumentId="271341877549174240"/>
 </Relationships>
  """
    When method post
    Then status 400
    #And match /Error/ErrorCode == 'ERROR_CODE'
    #And match /Error/ErrorDescription == 'Description for specific error'

  ############################################################################################################
  Scenario: Validate 400 when adding a document relationship with a BLANK direction _id
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="" RelatedDocumentId='271341877549174121' />
  </Relationships>
  """
    When method post
    Then status 400
    #why is it returning 500?
    #And match /Error/ErrorCode == 'ERROR_CODE'
    #And match /Error/ErrorDescription == 'Description for specific error'

  ############################################################################################################
  @run
  Scenario: Validate 400 when deleting a document relationship that is different to the one that exists
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174197"/>
  </Relationships>
  """
    # First add a relationship
    When method post
    Then status 201
    #Then def direction_id = response/Relationship/@Id
    # Now try to delete the relationship with different relationship to that was added.
    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    And header Content-Type = 'application/xml'
    And request <Relationships> <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId="271341877549174197"/> </Relationships>
    When method delete
    * print response
    Then status 400
    #And match /Error/ErrorCode == 'ERROR_CODE'
    #And match /Error/ErrorDescription == 'Description for specific error'

    Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
    # Then check the relationship was added
    When method get
    Then status 200
    And match /Relationships/Relationship/RelatedDocument/@Id == '#(target_doc_id)'
    And match /Relationships/Relationship/Direction/@Id == '#(direction_id)'
