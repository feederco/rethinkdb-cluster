FROM rethinkdb:2.3
COPY rethinkdb.sh /bin/
CMD ["bash", "/bin/rethinkdb.sh"]
