package org;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {

    final static Pattern pattern = Pattern.compile("^[1-9][0-9]{3}$");


    public static String unitdate(org.w3c.dom.Node node) {

        final String text = node.getNodeValue();

        int van = Integer.MAX_VALUE, tot = Integer.MIN_VALUE;

        final String str = text.replaceAll("[^\\d]", " ")
                .trim()
                .replaceAll(" +", " ");

        final String[] split = str.split(" ");
        for (String candidate : split) {
            final Matcher matcher = pattern.matcher(candidate);
            if (matcher.matches()) {
                final int n = Integer.parseInt(candidate);
                if (n < van) van = n;
                if (n > tot) tot = n;
            }
        }

        final String ret;
        if (van == Integer.MAX_VALUE && tot == Integer.MIN_VALUE) {
            System.out.println("No matches");
            ret = text;
        } else if (van == Integer.MAX_VALUE) {
            ret = String.valueOf(tot);
        } else if (tot == Integer.MIN_VALUE) {
            ret = String.valueOf(van);
        } else {
            ret = van + "-" + tot;
        }

        return ret;
    }

    public static String normalDate(String text) {
        return text.replaceAll("-", "");
    }
}
