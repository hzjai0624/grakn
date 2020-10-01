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

package grakn.core.query.pattern.constraint;

import grakn.core.common.exception.GraknException;
import grakn.core.query.pattern.variable.Variable;

import java.util.Set;

import static grakn.common.util.Objects.className;
import static grakn.core.common.exception.ErrorMessage.Query.INVALID_CASTING;

public abstract class Constraint {

    public abstract Variable owner();

    public abstract Set<? extends Variable> variables();

    public boolean isType() {
        return false;
    }

    public boolean isThing() {
        return false;
    }

    public TypeConstraint asType() {
        throw new GraknException(INVALID_CASTING.message(className(this.getClass()), className(TypeConstraint.class)));
    }

    public ThingConstraint asThing() {
        throw new GraknException(INVALID_CASTING.message(className(this.getClass()), className(ThingConstraint.class)));
    }
}
