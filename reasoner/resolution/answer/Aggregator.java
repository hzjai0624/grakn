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
 */

package grakn.core.reasoner.resolution.answer;

import grakn.core.common.exception.GraknException;
import grakn.core.concept.Concept;
import grakn.core.concept.answer.ConceptMap;
import graql.lang.pattern.variable.Reference;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import static grakn.core.common.exception.ErrorMessage.Internal.ILLEGAL_STATE;

public abstract class Aggregator {
    private final ConceptMap original;
    private final ConceptMap transformed;

    Aggregator(ConceptMap original, ConceptMap transformed) {
        // TODO refactor to clean up the ownership of operations and variable domains
        this.original = original;
        this.transformed = transformed;
    }

    public Aggregated aggregateWith(ConceptMap toAggregate) {
        ConceptMap unTransformed = unTransform(toAggregate);
        if (unTransformed == null) return null;
        if (unTransformed.concepts().isEmpty()) throw GraknException.of(ILLEGAL_STATE);
        assert unTransformed.concepts().keySet().stream().anyMatch(original.concepts().keySet()::contains);
        Map<Reference.Name, Concept> aggregatedMap = new HashMap<>(original.concepts());
        aggregatedMap.putAll(unTransformed.concepts());
        ConceptMap aggregatedConceptMap = new ConceptMap(aggregatedMap);
        return new Aggregated(aggregatedConceptMap, toAggregate);
    }

    public ConceptMap map() {
        return transformed;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final Aggregator that = (Aggregator) o;
        return original.equals(that.original) &&
                transformed.equals(that.transformed);
    }

    @Override
    public int hashCode() {
        return Objects.hash(original, transformed);
    }

    abstract ConceptMap unTransform(ConceptMap conceptMap);

    public static class Aggregated {

        private final ConceptMap aggregated;
        private final ConceptMap original;

        Aggregated(ConceptMap aggregated, ConceptMap original) {
            this.aggregated = aggregated;
            this.original = original;
        }

        public ConceptMap conceptMap() {
            return aggregated;
        }

        public ConceptMap original() {
            return original;
        }
    }
}
