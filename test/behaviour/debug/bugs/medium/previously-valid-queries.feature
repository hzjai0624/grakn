#
# Copyright (C) 2020 Grakn Labs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

#noinspection CucumberUndefinedStep
Feature: Graql Match Query

  Background: Open connection and create a simple extensible schema
    Given connection has been opened
    Given connection does not have any database
    Given connection create database: grakn
    Given connection open schema session for database: grakn
    Given session opens transaction of type: write
    Given the integrity is validated
    Given graql define
      """
      define
      person sub entity,
        plays friendship:friend,
        plays employment:employee,
        owns name,
        owns age,
        owns ref @key;
      company sub entity,
        plays employment:employer,
        owns name,
        owns ref @key;
      friendship sub relation,
        relates friend,
        owns ref @key;
      employment sub relation,
        relates employee,
        relates employer,
        owns ref @key;
      name sub attribute, value string;
      age sub attribute, value long;
      ref sub attribute, value long;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: write


  # TODO should be include the type itself in the return of `sub`
  Scenario: 'sub' can be used to match the specified type and all its supertypes, including indirect supertypes
    Given graql define
      """
      define
      writer sub person;
      scifi-writer sub writer;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match writer sub $x;
      """
    Then uniquely identify answer concepts
      | x            |
      | label:writer |
      | label:person |
      | label:entity |


  # TODO should be include the type itself in the return of `sub`
  Scenario: 'sub' can be used to retrieve all instances of types that are subtypes of a given type
    Given graql define
      """
      define

      child sub person;
      worker sub person;
      retired-person sub person;
      construction-worker sub worker;
      bricklayer sub construction-worker;
      crane-driver sub construction-worker;
      telecoms-worker sub worker;
      mobile-network-researcher sub telecoms-worker;
      smartphone-designer sub telecoms-worker;
      telecoms-business-strategist sub telecoms-worker;
      """
    Given transaction commits
    Given the integrity is validated
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert
      $a isa child, has name "Alfred", has ref 0;
      $b isa retired-person, has name "Barbara", has ref 1;
      $c isa bricklayer, has name "Charles", has ref 2;
      $d isa crane-driver, has name "Debbie", has ref 3;
      $e isa mobile-network-researcher, has name "Edmund", has ref 4;
      $f isa telecoms-business-strategist, has name "Felicia", has ref 5;
      $g isa worker, has name "Gary", has ref 6;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match
        $x isa $type;
        $type sub worker;
      """
    # Alfred and Barbara are not retrieved, as they aren't subtypes of worker
    Then uniquely identify answer concepts
      | x         | type                                |
      | key:ref:2 | label:bricklayer                    |
      | key:ref:2 | label:construction-worker           |
      | key:ref:2 | label:worker                        |
      | key:ref:3 | label:crane-driver                  |
      | key:ref:3 | label:construction-worker           |
      | key:ref:3 | label:worker                        |
      | key:ref:4 | label:mobile-network-researcher     |
      | key:ref:4 | label:telecoms-worker               |
      | key:ref:4 | label:worker                        |
      | key:ref:5 | label:telecoms-business-strategist  |
      | key:ref:5 | label:telecoms-worker               |
      | key:ref:5 | label:worker                        |
      | key:ref:6 | label:worker                        |


  # TODO should be include the type itself in the return of `sub`
  Scenario: 'sub!' matches the specified type and its direct subtypes
    Given graql define
      """
      define
      writer sub person;
      scifi-writer sub writer;
      musician sub person;
      flutist sub musician;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $x sub! person;
      """
    Then uniquely identify answer concepts
      | x              |
      | label:writer   |
      | label:musician |


  # TODO should be include the type itself in the return of `sub`
  Scenario: 'sub!' can be used to match the specified type and its direct supertype
    Given graql define
      """
      define
      writer sub person;
      scifi-writer sub writer;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match writer sub! $x;
      """
    Then uniquely identify answer concepts
      | x            |
      | label:person |



  # TODO do we want to allow `match $x 10;` as a query without `isa`?
  Scenario Outline: '<type>' attributes can be matched by value
    Given graql define
      """
      define <attr> sub attribute, value <type>, owns ref @key;
      """
    Given transaction commits
    Given the integrity is validated
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert $n <value> isa <attr>, has ref 0;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $a <value>;
      """
    Then uniquely identify answer concepts
      | a         |
      | key:ref:0 |

    Examples:
      | attr        | type     | value      |
      | colour      | string   | "Green"    |
      | calories    | long     | 1761       |
      | grams       | double   | 9.6        |
      | gluten-free | boolean  | false      |
      | use-by-date | datetime | 2020-06-16 |


  # TODO do we want to allow $x 10 as a query without `isa`?
  Scenario Outline: when matching a '<type>' attribute by a value that doesn't exist, an empty answer is returned
    Given graql define
      """
      define <attr> sub attribute, value <type>, owns ref @key;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $a <value>;
      """
    Then answer size is: 0

    Examples:
      | attr        | type     | value      |
      | colour      | string   | "Green"    |
      | calories    | long     | 1761       |
      | grams       | double   | 9.6        |
      | gluten-free | boolean  | false      |
      | use-by-date | datetime | 2020-06-16 |


 # TODO do we want to allow `match $x contains "..."` - similar to attribute predicate lookup, also without `isa`
 # TODO this currently throws an illegal start state because there is no Thing vertex start information, which can only be IID or a type
  # TODO otherwise it works if including "isa attribute"
  Scenario: 'contains' matches strings that contain the specified substring
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert
      $x "Seven Databases in Seven Weeks" isa name;
      $y "Four Weddings and a Funeral" isa name;
      $z "Fun Facts about Space" isa name;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $x contains "Fun";
      """
    Then uniquely identify answer concepts
      | x                                      |
      | value:name:Four Weddings and a Funeral |
      | value:name:Fun Facts about Space       |


   # TODO we are now case sensitive apparently! Must include "isa attribute" else same error as above
  Scenario: 'contains' performs a case-insensitive match
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert
      $x "The Phantom of the Opera" isa name;
      $y "Pirates of the Caribbean" isa name;
      $z "Mr. Bean" isa name;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $x contains "Bean";
      """
    Then uniquely identify answer concepts
      | x                                   |
      | value:name:Pirates of the Caribbean |
      | value:name:Mr. Bean                 |


  # TODO works if including `isa attribute`
  Scenario: 'like' matches strings that match the specified regex
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert
      $x "ABC123" isa name;
      $y "123456" isa name;
      $z "9" isa name;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    When get answers of graql query
      """
      match $x like "^[0-9]+$";
      """
    Then uniquely identify answer concepts
      | x                 |
      | value:name:123456 |
      | value:name:9      |

  Scenario: when multiple relation instances exist with the same roleplayer, matching that player returns just 1 answer
    Given graql define
      """
      define
      residency sub relation,
        relates resident,
        owns ref @key;
      person plays residency:resident;
      """
    Given transaction commits
    Given the integrity is validated
    Given connection close all sessions
    Given connection open data session for database: grakn
    Given session opens transaction of type: write
    Given graql insert
      """
      insert
      $x isa person, has ref 0;
      $e (employee: $x) isa employment, has ref 1;
      $f (friend: $x) isa friendship, has ref 2;
      $r (resident: $x) isa residency, has ref 3;
      """
    Given transaction commits
    Given the integrity is validated
    Given session opens transaction of type: read
    Given get answers of graql query
      """
      match $r isa relation;
      """
    Given uniquely identify answer concepts
      | r         |
      | key:ref:1 |
      | key:ref:2 |
      | key:ref:3 |
    When get answers of graql query
      """
      match ($x) isa relation;
      """
    Then uniquely identify answer concepts
      | x         |
      | key:ref:0 |
    When get answers of graql query
      """
      match ($x);
      """
    Then uniquely identify answer concepts
      | x         |
      | key:ref:0 |
