Feature: Handle all the Doc Linking API cases that result in HTTP 404 - NOT FOUND
  Reference Stories:
  XTN-4246: Implement exception handling for Authorization case

  Background:
    # Configuration
    * url 'https://qa106.aconex.com/api/document-relationships'
    * def basicAuth = read ('classpath:sign-in.js')
    * configure headers = read('classpath:default-headers.json')

    # Global Vars
    * def project_id =  '1879048454'
    * def source_doc_id = '271341877549174248'
    * def target_doc_id = '271341877549174268'
    * def has_deviation_of = '819cad43-0838-47f3-b4a3-e977fb1d0dfe'

    Given path 'projects', project_id, 'documents', source_doc_id , 'relationships'

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
      | GET    | 404    |
      | POST   | 404    |
      | DELETE | 404    |