Feature: Add Documents Relationships External API

Background:
  # Configuration
  * url 'https://qa106.aconex.com/api/document-relationships'
  * def basicAuth =
    """
    function(s){
      var auth_type = Java.type("BasicAuth");
      return 'Basic ' + auth_type.encode(s.username + ":" + s.password);
    }
    """
  * def poleary = call basicAuth { username:'poleary', password:'ac0n3x72'}
  * configure headers = read('classpath:default-headers.json')
  # Global Vars
  * def project_id =  '1879048400'
  * def source_doc_id = '271341877549134014'
  * def target_doc_id = '271341877549073143'
  * def direction_id = '819cad43-0838-47f3-b4a3-e977fb1d0dfe'

Scenario: Validate creating relationship between Doc1 and Doc 2 as poleary on Hotel VIP

  Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
  And path 'projects/#(project_id)/documents/#(doc_id)/relationships'
  And header Authorization = poleary
  And request
  """
  <Relationships>
  <Relationship DirectionId="819cad43-0838-47f3-b4a3-e977fb1d0dfe" RelatedDocumentId='271341877549073143' />
  </Relationships>
  """
  When method post
  Then status 201
  Then def relationship_id = response/Relationship/@Id

  Given path 'projects', project_id , 'documents', source_doc_id , 'relationships'
  When method get
  Then status 200
  And match /Relationships/Relationship/RelatedDocument/@Id == '#(target_doc_id)'
  And match /Relationships/Relationship/Direction/@Id == '#(direction_id)'

  #Validate the target document link works
#  * match response.Relationships..Link.Href == '/api/projects/1879048400/register/271341877549073143/metadata'
#  And path target_doc_link
#  Then status 200