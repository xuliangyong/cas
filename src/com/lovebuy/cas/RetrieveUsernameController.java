package com.lovebuy.cas;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.ticket.TicketGrantingTicket;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.jasig.cas.web.DelegateController;
import org.jasig.cas.web.support.ArgumentExtractor;
import org.jasig.cas.web.support.CookieRetrievingCookieGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;

/**
 * 返回jsonp
 * 
 * @author 徐良永
 * @2015年7月23日 下午4:30:09
 */
public class RetrieveUsernameController extends DelegateController {
	private final Logger log = LoggerFactory.getLogger(RetrieveUsernameController.class);

	@NotNull
	private CookieRetrievingCookieGenerator ticketGrantingTicketCookieGenerator;

	@NotNull
	@Size(min = 1)
	private List<ArgumentExtractor> argumentExtractors;
	
    /** TicketRegistry for storing and retrieving tickets as needed. */
    @NotNull
    private TicketRegistry ticketRegistry;

    /** New Ticket Registry for storing and retrieving services tickets. Can point to the same one as the ticketRegistry variable. */
    @NotNull
    private TicketRegistry serviceTicketRegistry;

	@Override
	public boolean canHandle(HttpServletRequest request,
			HttpServletResponse response) {
		return true;
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String tgtId = this.ticketGrantingTicketCookieGenerator.retrieveCookieValue(request);
		log.info("TGT: " + tgtId);
		
		TicketGrantingTicket ticketGrantingTicket = null;
		if(StringUtils.isNotBlank(tgtId)){
			ticketGrantingTicket = (TicketGrantingTicket) this.ticketRegistry.getTicket(tgtId, TicketGrantingTicket.class);
		}
        
        
        String username = null;
        if(ticketGrantingTicket != null){
        	username = ticketGrantingTicket.getAuthentication().getPrincipal().getId();
        }
		
        String jsonp = "jsonpResponse({\"id\":\"%s\"})";
        response.setContentType("text/html;charset=UTF-8"); 
        response.getWriter().write(String.format(jsonp, username));
        response.getWriter().flush();

		
		return null;
	}
	

	public void setTicketGrantingTicketCookieGenerator(
			final CookieRetrievingCookieGenerator ticketGrantingTicketCookieGenerator) {
		this.ticketGrantingTicketCookieGenerator = ticketGrantingTicketCookieGenerator;
	}

	public void setArgumentExtractors(
			final List<ArgumentExtractor> argumentExtractors) {
		this.argumentExtractors = argumentExtractors;
	}
	
    public void setTicketRegistry(final TicketRegistry ticketRegistry) {
        this.ticketRegistry = ticketRegistry;

        if (this.serviceTicketRegistry == null) {
            this.serviceTicketRegistry = ticketRegistry;
        }
    }

    public void setServiceTicketRegistry(final TicketRegistry serviceTicketRegistry) {
        this.serviceTicketRegistry = serviceTicketRegistry;
    }

}
