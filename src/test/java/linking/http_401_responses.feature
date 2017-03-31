Feature: Handle all the Doc Linking API cases that result in HTTP 401 - UNAUTHORISED

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

    Examples:
      | method | status |
      | GET    | 401    |
      | POST   | 401    |
      | DELETE | 401    |