package org;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class Rapport {


    private final List<Transformer> transformers = new ArrayList<>();

    private Rapport() {

        final TransformerFactory tf = TransformerFactory.newInstance();

        final String[] _transformers = {"/rapport.xsl"};
        for (String _transformer : _transformers) {

            final URL resource = this.getClass().getResource(_transformer);
            Source source = null;
            try {
                source = new StreamSource(resource.openStream());
            } catch (IOException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }

            source.setSystemId(resource.toString());

            try {
                transformers.add(tf.newTransformer(source));
            } catch (TransformerConfigurationException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }
        }

    }

    private void run(String source_folder, String target_folder) throws IOException, TransformerException {

        final File[] source_files = new File(source_folder).listFiles();
        if (source_files == null) {
            System.out.print("The folder has no files: " + source_folder);
            System.exit(-1);
        }

        final File targetFolder = new File(target_folder);
        if (!targetFolder.exists() && !targetFolder.mkdirs()) {
            System.out.print("Failed to create folder " + target_folder);
            System.exit(-1);
        }

        for (File source_file : source_files) {
            final FileInputStream source = new FileInputStream(source_file);

            final int length = (int) source_file.length();
            byte[] record = new byte[length];

            final int total = source.read(record, 0, length);

            final String name = source_file.getName().replace(".xml", ".txt");

            System.out.println(source_file.getAbsolutePath() + " " + total + " " + name);
            for (Transformer transformer : transformers) {
                record = convertRecord(transformer, record);
            }

            File target = new File(targetFolder, name);
            FileOutputStream fos = new FileOutputStream(target);
            fos.write(record);
        }
    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        return baos.toByteArray();
    }

    /**
     * main
     *
     * @param args 0=source folder; 1=destination folder
     */
    public static void main(String[] args) throws IOException, TransformerException {

        final String in = args[0];
        final String out = args[1];

        System.out.println("In " + in);
        System.out.println("Out " + out);
        new Rapport().run(in, out);
    }
}
