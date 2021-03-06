/**
 * Copyright (c) 2012 Partners In Health.  All rights reserved.
 * The use and distribution terms for this software are covered by the
 * Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
 * which can be found in the file epl-v10.html at the root of this distribution.
 * By using this software in any fashion, you are agreeing to be bound by
 * the terms of this license.
 * You must not remove this notice, or any other, from this software.
 **/
package org.pih.warehouse.inventory

import org.pih.warehouse.jobs.RefreshProductAvailabilityJob
import org.springframework.context.ApplicationListener
class TransactionEventService implements ApplicationListener<TransactionEvent> {

    boolean transactional = true

    void onApplicationEvent(TransactionEvent event) {
        log.info "Application event $event has been published!"
        Transaction transaction = event?.source
        def transactionId = transaction?.id
        def transactionDate = transaction?.transactionDate
        def locationId = event.associatedLocation
        List productIds = event.associatedProducts

        log.info "Refresh inventory snapshot " +
            "date=$transactionDate, " +
            "location=$locationId, " +
            "transaction=$transactionId," +
            "productIds=$productIds"

        RefreshProductAvailabilityJob.triggerNow([
            locationId: locationId,
            productIds: productIds
        ])
    }
}
