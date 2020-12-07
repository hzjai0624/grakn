/*
 * Copyright (C) 2020 Grakn Labs
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

package grakn.core.concept.logic;

import grakn.core.pattern.Conjunction;
import grakn.core.pattern.constraint.Constraint;

import java.util.Set;

public interface Rule {

    String getLabel();

    void setLabel(String label);

    graql.lang.pattern.Conjunction<? extends graql.lang.pattern.Pattern> getWhenPreNormalised();

    graql.lang.pattern.variable.ThingVariable<?> getThenPreNormalised();

    Conjunction when();

    Set<Constraint> then();

    boolean isDeleted();

    void delete();
}