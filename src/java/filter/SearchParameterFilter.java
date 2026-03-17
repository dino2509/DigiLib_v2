package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

import jakarta.servlet.annotation.WebFilter;

import jakarta.servlet.http.HttpServletRequest;

@WebFilter("/reader/advanced-search")
public class SearchParameterFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        String priceMin = req.getParameter("priceMin");
        String priceMax = req.getParameter("priceMax");

        try {

            if (priceMin != null && !priceMin.isEmpty()) {
                int min = Integer.parseInt(priceMin);
                if (min < 0) {
                    req.setAttribute("priceError",
                            "Minimum price must be >= 0");
                }
            }

            if (priceMax != null && !priceMax.isEmpty()) {
                int max = Integer.parseInt(priceMax);
                if (max < 0) {
                    req.setAttribute("priceError",
                            "Maximum price must be >= 0");
                }
            }

        } catch (NumberFormatException e) {
            req.setAttribute("priceError",
                    "Price must be numeric");
        }

        chain.doFilter(request, response);
    }
}
