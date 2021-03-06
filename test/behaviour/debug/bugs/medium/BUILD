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

package(default_visibility = ["//visibility:__subpackages__"])
load("@graknlabs_dependencies//tool/checkstyle:rules.bzl", "checkstyle_test")

java_test(
    name = "previously-valid-queries-test",
    srcs = [
        "PreviouslyValidQueriesTest.java",
    ],
    test_class = "grakn.core.test.behaviour.debug.bugs.medium.PreviouslyValidQueriesTest",
    deps = [
        # Internal dependencies

        # Add your additional debugging dependencies here
        # e.g. "//test/behaviour/connection/session:steps",

        # External Maven Dependencies
        "@maven//:io_cucumber_cucumber_java",
        "@maven//:io_cucumber_cucumber_junit",
    ],
    runtime_deps = [
        "//test/behaviour/config:parameters",
        "//test/behaviour/concept/thing/entity:steps",
        "//test/behaviour/concept/thing/attribute:steps",
        "//test/behaviour/concept/thing/relation:steps",
        "//test/behaviour/concept/type/attributetype:steps",
        "//test/behaviour/concept/type/relationtype:steps",
        "//test/behaviour/concept/type/thingtype:steps",
        "//test/behaviour/connection/database:steps",
        "//test/behaviour/connection/session:steps",
        "//test/behaviour/connection/transaction:steps",
        "//test/behaviour/graql:steps",
    ],
    data = [
        ":previously-valid-queries.feature",
    ],
    size = "medium",
)

java_test(
    name = "query-planner-test",
    srcs = [
        "QueryPlannerTest.java",
    ],
    test_class = "grakn.core.test.behaviour.debug.bugs.medium.QueryPlannerTest",
    deps = [
        # Internal dependencies

        # Add your additional debugging dependencies here
        # e.g. "//test/behaviour/connection/session:steps",

        # External Maven Dependencies
        "@maven//:io_cucumber_cucumber_java",
        "@maven//:io_cucumber_cucumber_junit",
    ],
    runtime_deps = [
        "//test/behaviour/config:parameters",
        "//test/behaviour/concept/thing/entity:steps",
        "//test/behaviour/concept/thing/attribute:steps",
        "//test/behaviour/concept/thing/relation:steps",
        "//test/behaviour/concept/type/attributetype:steps",
        "//test/behaviour/concept/type/relationtype:steps",
        "//test/behaviour/concept/type/thingtype:steps",
        "//test/behaviour/connection/database:steps",
        "//test/behaviour/connection/session:steps",
        "//test/behaviour/connection/transaction:steps",
        "//test/behaviour/graql:steps",
    ],
    data = [
        ":query-planner-bug.feature",
    ],
    size = "medium",
)

java_test(
    name = "role-scoping-test",
    srcs = [
        "RoleScopingTest.java",
    ],
    test_class = "grakn.core.test.behaviour.debug.bugs.medium.RoleScopingTest",
    deps = [
        # Internal dependencies

        # Add your additional debugging dependencies here
        # e.g. "//test/behaviour/connection/session:steps",

        # External Maven Dependencies
        "@maven//:io_cucumber_cucumber_java",
        "@maven//:io_cucumber_cucumber_junit",
    ],
    runtime_deps = [
        "//test/behaviour/config:parameters",
        "//test/behaviour/concept/thing/entity:steps",
        "//test/behaviour/concept/thing/attribute:steps",
        "//test/behaviour/concept/thing/relation:steps",
        "//test/behaviour/concept/type/attributetype:steps",
        "//test/behaviour/concept/type/relationtype:steps",
        "//test/behaviour/concept/type/thingtype:steps",
        "//test/behaviour/connection/database:steps",
        "//test/behaviour/connection/session:steps",
        "//test/behaviour/connection/transaction:steps",
        "//test/behaviour/graql:steps",
    ],
    data = [
        ":role-scoping.feature",
    ],
    size = "medium",
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "agpl",
)
